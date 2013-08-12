class Proposal < ActiveRecord::Base
  attr_accessible :group_id, :from, :to, :round_id,
                  :money_a, :money_b, :money_c,
                  :submiter_penalty, :accepter_penalty

  validates :group_id, :from, :to, :round_id, :money_a, :money_b, :money_c, presence: true

  belongs_to :group
  
  def self.current_round_is_over?(round_id, group_id)
    proposals = Proposal.where('group_id = ? AND round_id = ? AND accept = ?',
                                group_id, round_id, true)
    if proposals.length > 0
      true
    else
      false
    end

  end

  # current decision to user_id
  def self.current_decision(round_id, group_id)
    Proposal.where(group_id: group_id,
                   round_id: round_id,
                   accept: true).first
  end

    def self.last_round_decision(round_id, group_id)
    if (round_id == 0)
      nil
    else
      Proposal.where(group_id: group_id,
                     round_id: round_id - 1,
                     accept: true).first
    end
  end

  # from: user_id
  # to: user_id,
  # group_id: group.id
  # round_id: round_id
  def self.last_proposal(params = {})

    if current_round_is_over?(params[:round_id], params[:group_id])
      nil
    else
      proposal = Proposal.where(from: params[:from],
                                to: params[:to],
                                group_id: params[:group_id],
                                round_id: params[:round_id],
                                accept: false).
                          order('updated_at DESC').first

      proposal

    end
  end

  def self.submit_proposal(params = {})
    round_id = User.find(params[:from]).round_id
    if current_round_is_over?(round_id, params[:group_id])
      nil
    else
      p = Proposal.new(params)
      p.accept = false
      p.round_id = round_id
      p.submiter_penalty = 0
      p.accepter_penalty = 0
      if p.save!
        p
      else
        nil
      end

    end
  end

  def self.accept_proposal(params = {})
    round_id = User.find(params[:to]).round_id
    if current_round_is_over?(round_id, params[:group_id])
      nil
    else
      p = Proposal.find(params[:proposal_id])
      unless p
        raise 'No proposal found'
      end

      p.accept = true
      if p.save!
        # add round_id
        group = Group.find(params[:group_id])
        group.round_id += 1
        group.save!
        
        # update user's earning points
        submiter_penalty, accepter_penalty = group.update_users_from_group(params[:from], params[:to], round_id, [p.money_a, p.money_b, p.money_c])
        p.submiter_penalty = submiter_penalty
        p.accepter_penalty = accepter_penalty
        p.save!
      else
        nil
      end

    end

  end



  # decision: 0 - no_decision
  #           1 - accept
  #           2 - reject

#  def is_pending?
#    decisions = [self.decision_a, self.decision_b, self.decision_c]
#    rejects = decisions.select {|d| d == 2} .length
#    if rejects >=2
#      fa   end
#  end
#
#  def self.have_current_pending_proposal?(user_id, round_id)
#    p = Proposal.where('user_id = ? AND round_id = ?', user_id, round_id)
#    if p.length > 0
#      true
#    else
#      false
#    end
#  end
#
#  def self.accept(user_id, proposal_id)
#    if !user_id || !proposal_id
#      raise 'Parameter error'
#    end
#
#    p = Proposal.find(proposal_id)
#    if user_id == p.id
#      raise 'Cannot accept yourself'
#    end
#
#    users = Group.find(p.group_id).users
#    users.sort! {|x, y| x.id <=> y.id}
#
#    users.each_with_index do |x, i|
#      #puts i, user_id, x.id
#
#      if i == 0 && user_id == x.id
#        p.decision_a = 1
#      end
#      if i == 1 && user_id == x.id
#        p.decision_b = 1
#      end
#
#      if user_id == x.id
#        p.decision_c = 1
#      end
#    end
#
#    p.state = 'accept'
#
#    if p.save
#      {:result => 'accept ok',
#       :proposal => p}
#    else
#      {:result => 'accept fail'}
#    end
#
#  end
#
#
#  def self.create_from_user(user_id, group_id, round_id, proposal_json)
#    if !user_id || !group_id || !round_id
#      raise 'Parameter error'
#    end
#
#    if have_current_pending_proposal?(user_id, round_id)
#      raise 'Only one proposal allowed to be pending in current round'
#    end
#
#    decision = current_decision(group_id, round_id)
#    if decision[:have]
#      return {:create_status => 'FAIL: only one pending proposal allowed'}
#    end
#
#    p = Proposal.new()
#    p.user_id = user_id
#    p.group_id = group_id
#    p.round_id = round_id
#    money_array = []
#    #self
#    money_array[0] = [user_id, proposal_json[:self].to_i, 1]
#
#    #opponents
#    proposal_json[:opponents].values.each do |pair|
#      u = User.find_by_name(pair['user_name'])
#      money_array.append([u.id, pair['money'].to_i, 0])
#    end
#
#    #sort by user_id
#    money_array.sort! {|a, b| a[0] <=> b[0]}
#
#    #only interested in money and decisions
#    moneys_decisions = money_array.map {|e| [e[1], e[2]]}
#
#    p.money_a = moneys_decisions[0][0]
#    p.decision_a = moneys_decisions[0][1]
#
#    p.money_b = moneys_decisions[1][0]
#    p.decision_b = moneys_decisions[1][1]
#
#    p.money_c = moneys_decisions[2][0]
#    p.decision_c = moneys_decisions[2][1]
#
#    p.state = 'pending'
#
#    unless p.save
#      raise 'proposal saved error'
#    end
#
#    {:create_status => 'OK'}
#
#  end
#
#  #get current pending proposals
#  def self.current_proposal(user_id, round_id)
#    proposals = Proposal.where('user_id = ? AND round_id = ? AND state = ?', user_id, round_id, 'pending')
#    if proposals.length > 1
#      raise "One user's pending proposal should only be 1"
#    end
#
#    if proposals.length == 1
#      p = proposals[0]
#
#      {:moneys => [p.money_a, p.money_b, p.money_c],
#       :decisions => [p.decision_a, p.decision_b, p.decision_c],
#       :proposal_id => p.id
#      }
#    else
#      {:moneys => [],
#       :decisions => []
#      }
#    end
#
#  end
#
#  #get proposals accepted or rejected
#  def self.current_decision(group_id, round_id)
#    proposals = Proposal.where('group_id = ? AND round_id = ? AND state != ?', group_id, round_id, 'pending')
#
#    accept_p, reject_p = proposals.partition {|p| p.state == 'accept'}
#    if accept_p.length == 0 && reject_p.length == 0
#      {
#          :have => false,
#          :proposals => []
#      }
#    elsif accept_p.length > 1
#      raise 'Only one proposal accepted for current round'
#    else
#      {
#          :have => true,
#          :proposals => accept_p + reject_p
#      }
#    end
#
#  end
#
#
end
