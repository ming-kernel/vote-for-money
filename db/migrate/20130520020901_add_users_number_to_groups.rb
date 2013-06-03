class AddUsersNumberToGroups < ActiveRecord::Migration
  def change
    add_column :groups, :users_number, :integer
  end
end
