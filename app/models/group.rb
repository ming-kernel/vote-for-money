class Group < ActiveRecord::Base
  has_many :users
  attr_accessible :users_number, :round_id

  validates :users_number, :round_id, :presence => true
  validates :users_number, :numericality => {:less_than_or_equal_to => 3,
                                            :greater_than => 0}
  validates :round_id, :numericality => {:greater_than_or_equal_to => 0}


end
