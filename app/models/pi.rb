class Pi < ActiveRecord::Base
  attr_accessible :digits_known, :next_test, :user_id
  validates :user_id,presence: :true

  belongs_to :user
end
