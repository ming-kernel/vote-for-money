class Group < ActiveRecord::Base
  has_many :users
  attr_accessible :users_number, :round_id

  validates :users_number, :round_id, :presence => true
  validates :users_number, :numericality => {:less_than_or_equal_to => 3,
                                            :greater_than => 0}
  validates :round_id, :numericality => {:greater_than_or_equal_to => 0}


  def update_users_from_group(moneys)
    users = self.users
    users.sort! { |a, b| a.id <=> b.id }
    users.each_index do |i| 
      users[i].earnings += moneys[i]
      # users[i].round_id = self.round_id
      users[i].save!
    end

  end

end
