class AddNumbersToUsers < ActiveRecord::Migration
  def change
    add_column :users, :pidigits, :integer
    add_column :users, :edigits, :integer
    add_column :users, :phidigits, :integer
    add_column :users, :usetau, :boolean
  end
end
