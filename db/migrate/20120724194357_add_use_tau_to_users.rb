class AddUseTauToUsers < ActiveRecord::Migration
  def change
    add_column :users, :use_tau, :boolean, default: false
  end
end
