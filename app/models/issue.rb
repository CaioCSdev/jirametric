# frozen_string_literal: true

class Issue < ApplicationRecord
  belongs_to :project
  has_many :changelogs

  def self.from_jira(json)
    issue = find_or_initialize_by key: json["key"]
    issue.link = json["self"]
    issue.summary = json["fields"]["summary"]
    issue.description = json["fields"]["description"]

    issue
  end
end
