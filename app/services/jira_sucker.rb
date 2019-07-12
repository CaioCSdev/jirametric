# frozen_string_literal: true

class JiraSucker
  HOST = "https://gogogoninjas.atlassian.net"

  def initialize(user, pass)
    @userpwd = "#{user}:#{pass}"
  end

  def factory_projects
    path = "/rest/api/2/project"

    response = Typhoeus::Request.get("#{HOST}#{path}", userpwd: @userpwd)
    projects = JSON.parse response.body

    projects.each do |project|
      p = Project.from_jira(project)
      p.save
    end
  end

  def factory_issues(project_key)
    path = "/rest/api/2/search"
    body = {
      jql: "project = #{project_key.key}",
      startAt: 0,
      maxResults: 100,
      fields: [
        "summary",
        "description",
      ],
    }

    loop do
      response = Typhoeus::Request.new(
        "#{HOST}#{path}",
        method: :post,
        body: body.to_json,
        userpwd: @userpwd,
        headers: {"Content-Type" => "application/json"}
      ).run

      issues = JSON.parse(response.body)["issues"]
      break if issues.empty?

      create_issues(issues, project_key.key)
      body[:startAt] += 100
    end
  end

  def create_issues(issues, pkey)
    issues.each do |issue|
      i = Issue.from_jira(issue)
      i.project = Project.find_by(key: pkey)
      i.save
    end
  end

  def factory_all_issues
    projects_keys = Project.all.select(:key)
    projects_keys.each do |pkey|
      factory_issues pkey
    end
  end

  def factory_all_changelogs
    issues = Issue.all
    issues.each do |issue|
      factory_changelog issue
    end
  end

  def factory_changelog(issue)
    path = "/rest/api/2/issue/#{issue.key}?expand=changelog"
    params = {
      expand: "changelog",
      fields: "key",
    }

    response = Typhoeus::Request.get(
      "#{HOST}#{path}",
      userpwd: @userpwd,
      params: params
    )
    histories = JSON.parse(response.body)["changelog"]["histories"]

    Changelog.factory_from_histories(issue, histories)
  end
end
