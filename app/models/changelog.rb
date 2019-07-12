# frozen_string_literal: true

class Changelog < ApplicationRecord
  belongs_to :issue

  def self.factory_from_histories(issue, histories)
    Changelog.only_status_histories histories

    histories.each do |history|
      changelog = find_or_initialize_by when: DateTime.parse(history["created"])
      changelog.from = history["items"][0]["fromString"]
      changelog.to = history["items"][0]["toString"]
      changelog.issue = issue
      changelog.save!
    end
  end

  def self.only_status_histories(histories)
    histories.select! do |history|
      history["items"].select! do |item|
        item["field"] == "status"
      end

      !history["items"].empty?
    end
  end
end
