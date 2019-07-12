# frozen_string_literal: true

class Project < ApplicationRecord
  has_many :issues

  def self.from_jira(json)
    project = find_or_initialize_by key: json["key"]
    project.name = json["name"]
    project.link = json["self"]
    project.description = json["description"]

    project
  end
end
