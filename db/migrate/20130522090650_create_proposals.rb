class CreateProposals < ActiveRecord::Migration
  def change
    create_table :proposals do |t|
      t.integer :user_id
      t.integer :group_id
      t.integer :round_id
      t.decimal :money_a
      t.decimal :money_b
      t.decimal :money_c

      t.timestamps
    end
  end
end
