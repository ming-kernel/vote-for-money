class AddFromtoToProposals < ActiveRecord::Migration
  def up
    rename_column :proposals, :user_id, :from
    add_column :proposals, :to, :integer
  end

  def down
    rename_column :proposals, :from, :user_id
    remove_column :proposals, :to

  end
end
