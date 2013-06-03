class DropResultsTable < ActiveRecord::Migration
  def up
    drop_table :decisions
    add_column :proposals, :accept, :boolean

  end

  def down
    create_table :decisions
    remove_column :proposals, :accept
  end
end
