class AddDecisionAToProposals < ActiveRecord::Migration
  def change
    add_column :proposals, :decision_a, :boolean
  end
end
