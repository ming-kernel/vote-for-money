class RemoveEmailFromUsers < ActiveRecord::Migration
  def change
    remove_column :users, :email
  end

  def down
  end
end
