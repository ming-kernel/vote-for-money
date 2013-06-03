class ChangeDecisionFormatInProposals < ActiveRecord::Migration
  def up
    remove_column :proposals, :decision_a
    remove_column :proposals, :decision_b
    remove_column :proposals, :decision_c

    add_column :proposals, :decision_a, :integer
    add_column :proposals, :decision_b, :integer
    add_column :proposals, :decision_c, :integer

  end


  def down
    remove_column :proposals, :decision_a
    remove_column :proposals, :decision_b
    remove_column :proposals, :decision_c

    add_column :proposals, :decision_a, :boolean
    add_column :proposals, :decision_b, :boolean
    add_column :proposals, :decision_c, :boolean


  end
end
