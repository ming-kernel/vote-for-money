class Group < ActiveRecord::Base
  has_many :users
  has_many :proposals
  
  attr_accessible :users_number, :round_id, :betray_penalty
  attr_writer :users, :proposals
  validates :users_number, :round_id, :presence => true
  validates :users_number, :numericality => {:less_than_or_equal_to => 3,
                                            :greater_than => 0}

  validates :round_id, :numericality => {:greater_than_or_equal_to => 0}

  validates :betray_penalty, :presence => true

  def penalty(this_id, other_id, round_id)
    if round_id == 0
      0
    else
      last_round = round_id - 1
      last_decision = Proposal.where(group_id: self.id, round_id: last_round, accept: true).first
      if (!last_decision)
        raise 'Not possible'
      end

      if (last_decision.from == this_id && last_decision.to != other_id)
        return self.betray_penalty
      end

      if (last_decision.to == this_id && last_decision.from != other_id)
        return self.betray_penalty
      end

      return 0

    end
  end

  # def penalty_for_accepter(from_id, to_id, round_id)
  #   if round_id == 0
  #     0
  #   else
  #     last_round = round_id - 1
  #     last_decision = Proposal.where("group_id = :group_id AND round_id = :round_id AND accept = :value",
  #                    {:group_id => self.id, :round_id => last_round, :value => true}).first
  #     if (!decisions)
  #       0
  #     else
  #       if (last_decision.from == to_id && last_decision.to != from_id)
  #         self.betray_penalty
  #       elsif (last_decision.to == to_id && last_decision.from != from_id)
  #         self.betray_penalty
  #       else
  #         0
  #       end
  #     end

  #   end
  # end

  # def penalty_for_submiter(from_id, to_id, round_id)
  #   if round_id == 0
  #     0
  #   else
  #     last_round = round_id - 1
  #     last_decision = Proposal.where("group_id = :group_id AND round_id = :round_id AND accept = :value",
  #                    {:group_id => self.id, :round_id => last_round, :value => true}).first
  #     if (!last_decision)
  #       0
  #     else
  #       if (last_decision.from == from_id && last_decision.to != to_id)
  #         self.betray_penalty
  #       elsif (last_decision.to == from_id && last_decision.from != to_id)
  #         self.betray_penalty
  #       else
  #         0
  #       end
  #     end
  #   end
  # end

  def update_users_from_group(from_id, to_id, round_id, moneys)
    submiter_penalty = 0
    accepter_penalty = 0
    users = self.users
    users.sort! { |a, b| a.id <=> b.id }
    users.each_index do |i| 
      users[i].earnings += moneys[i]
      if users[i].id == to_id
        # accepter_penalty = penalty_for_accepter(from_id, to_id, round_id)
        accepter_penalty = penalty(to_id, from_id, round_id)
        users[i].earnings -= accepter_penalty
      end

      if users[i].id == from_id
        # submiter_penalty = penalty_for_submiter(from_id, to_id, round_id)
        submiter_penalty = penalty(from_id, to_id, round_id)
        users[i].earnings -= submiter_penalty
      end

      users[i].save!
      
    end
    [submiter_penalty, accepter_penalty]
  end

end
