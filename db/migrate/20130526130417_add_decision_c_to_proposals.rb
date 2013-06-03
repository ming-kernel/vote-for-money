class AddDecisionCToProposals < ActiveRecord::Migration
  def change
    add_column :proposals, :decision_c, :boolean
  end
end
