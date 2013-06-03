class AddDecisionBToProposals < ActiveRecord::Migration
  def change
    add_column :proposals, :decision_b, :boolean
  end
end
