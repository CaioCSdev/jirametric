# frozen_string_literal: true

class Issue < ApplicationRecord
  belongs_to :project
  has_many :changelogs
end
