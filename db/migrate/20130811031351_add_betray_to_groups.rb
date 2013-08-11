class AddBetrayToGroups < ActiveRecord::Migration
  def change
    add_column :groups, :betray_penalty, :integer
  end
end
