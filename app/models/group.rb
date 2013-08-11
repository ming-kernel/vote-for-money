class Group < ActiveRecord::Base
  has_many :users
  attr_accessible :users_number, :round_id, :betray_penalty

  validates :users_number, :round_id, :presence => true
  validates :users_number, :numericality => {:less_than_or_equal_to => 3,
                                            :greater_than => 0}

  validates :round_id, :numericality => {:greater_than_or_equal_to => 0}

  validates :betray_penalty, :presence => true

  def penalty_for_accepter(from_id, to_id, round_id)
    if round_id == 0
      0
    else
      decisions = Proposal.where("group_id = :group_id AND round_id < :round_id AND proposals.to = :to AND accept = :value",
                     {:group_id => self.id, :round_id => round_id, :to => to_id, :value => true})
      if (decisions.length == 0)
        0
      else
        decisions.sort! {|x, y| y.round_id <=> x.round_id}
        if decisions[0].from != from_id
          self.betray_penalty
        else
          0
        end
      end

    end
  end

  def penalty_for_sumbiter(from_id, to_id, round_id)
    if round_id == 0
      0
    else
      decisions = Proposal.where("group_id = :group_id AND round_id < :round_id AND proposals.from = :from AND accept = :value",
                     {:group_id => self.id, :round_id => round_id, :from => from_id, :value => true})
      if (decisions.length == 0)
        0
      else
        decisions.sort! {|x, y| y.round_id <=> x.round_id}
        if decisions[0].to != to_id
          self.betray_penalty
        else
          0
        end
      end
    end
  end

  def update_users_from_group(from_id, to_id, round_id, moneys)
    penalty_from = 0
    penalty_to = 0
    users = self.users
    users.sort! { |a, b| a.id <=> b.id }
    users.each_index do |i| 
      users[i].earnings += moneys[i]
      if users[i].id == to_id
        penalty_to = penalty_for_accepter(from_id, to_id, round_id)
        users[i].earnings -= penalty_to
      end

      if users[i].id == from_id
        penalty_from = penalty_for_sumbiter(from_id, to_id, round_id)
        users[i].earnings -= penalty_from
      end

      users[i].save!
      
    end
    [penalty_from, penalty_to]
  end

end
