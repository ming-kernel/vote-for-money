class AddDecisions < ActiveRecord::Migration
  def up
    create_table :decisions do |t|
      t.integer :user_id
      t.integer :proposal_id
      t.boolean :accept
    end

    remove_columns :proposals, :decision_a, :decision_b, :decision_c
  end

  def down
    drop_table :decisions
    add_column :proposals, :decision_a, :integer
    add_column :proposals, :decision_b, :integer
    add_column :proposals, :decision_c, :integer

  end
end
