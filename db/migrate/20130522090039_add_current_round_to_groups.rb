class AddCurrentRoundToGroups < ActiveRecord::Migration
  def change
    add_column :groups, :current_round, :integer
  end
end
