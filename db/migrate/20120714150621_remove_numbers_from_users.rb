class RemoveNumbersFromUsers < ActiveRecord::Migration
  def up
    remove_column :users, :pidigits
    remove_column :users, :edigits
    remove_column :users, :phidigits
    remove_column :users, :usetau
  end

  def down
    add_column :users, :usetau, :boolean
    add_column :users, :phidigits, :integer
    add_column :users, :edigits, :integer
    add_column :users, :pidigits, :integer
  end
end
