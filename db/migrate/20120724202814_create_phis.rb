class CreatePhis < ActiveRecord::Migration
  def change
    create_table :phis do |t|
      t.integer :user_id
      t.integer :digits_known
      t.datetime :next_test

      t.timestamps
    end
  end
end
