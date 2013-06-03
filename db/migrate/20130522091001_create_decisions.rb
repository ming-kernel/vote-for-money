class CreateDecisions < ActiveRecord::Migration
  def change
    create_table :decisions do |t|
      t.integer :user_id
      t.integer :proposal_id
      t.string :choice

      t.timestamps
    end
  end
end
