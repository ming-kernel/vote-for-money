class CreateResults < ActiveRecord::Migration
  def change
    create_table :results do |t|
      t.integer :group_id
      t.integer :round_id
      t.integer :proposal_id

      t.timestamps
    end
  end
end
