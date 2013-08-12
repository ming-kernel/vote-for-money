class RenamePenalty < ActiveRecord::Migration
  def change
    rename_column :proposals, :penalty_from, :submiter_penalty
    rename_column :proposals, :penalty_to, :accepter_penalty
  end

end
