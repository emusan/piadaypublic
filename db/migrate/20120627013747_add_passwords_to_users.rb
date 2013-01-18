class AddPasswordsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :password, :string
    add_column :users, :password_confirmation, :string
  end
  add_index :users,:email,unique: true
end
