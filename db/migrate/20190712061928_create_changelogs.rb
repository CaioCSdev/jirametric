# frozen_string_literal: true

class CreateChangelogs < ActiveRecord::Migration[6.0]
  def change
    create_table :changelogs do |t|
      t.string :from
      t.string :to
      t.datetime :when
      t.references :issue

      t.timestamps
    end
  end
end
