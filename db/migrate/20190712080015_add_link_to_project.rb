class AddLinkToProject < ActiveRecord::Migration[6.0]
  def change
    add_column :projects, :link, :string
  end
end
