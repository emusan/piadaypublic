class AddTestFrequencyToUsers < ActiveRecord::Migration
  def change
    add_column :users, :test_frequency, :integer
  end
end
