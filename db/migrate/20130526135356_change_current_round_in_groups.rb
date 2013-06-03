class ChangeCurrentRoundInGroups < ActiveRecord::Migration
  def up
    rename_column :groups, :current_round, :round_id
  end

  def down
    rename_column :groups, :round_id, :current_round
  end
end
