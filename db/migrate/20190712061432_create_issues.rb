# frozen_string_literal: true

class CreateIssues < ActiveRecord::Migration[6.0]
  def change
    create_table :issues do |t|
      t.text :summary
      t.string :key
      t.text :description
      t.string :link
      t.references :project

      t.timestamps
    end
  end
end
