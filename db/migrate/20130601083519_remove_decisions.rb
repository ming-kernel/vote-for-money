class RemoveDecisions < ActiveRecord::Migration
  def up
    drop_table :decisions
  end

  def down
    create_table :decisions
  end
end
