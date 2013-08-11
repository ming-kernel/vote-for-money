class AddPenaltyToProposals < ActiveRecord::Migration
  def change
    add_column :proposals, :penalty_from, :integer
    add_column :proposals, :penalty_to, :integer
  end
end
