class RemoveStateFromProposals < ActiveRecord::Migration
  def up
    remove_column :proposals, :state
  end

  def down
    add_column :proposals, :state, :string
  end
end
