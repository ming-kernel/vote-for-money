class DropResults < ActiveRecord::Migration
  def up
    drop_table :results
  end

  def down
    create_table :results
  end
end
