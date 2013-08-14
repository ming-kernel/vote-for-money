class AddPlainPasswordToUsers < ActiveRecord::Migration
  def change
    add_column :users, :plain_password, :string
  end
end
