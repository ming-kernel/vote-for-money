require 'spec_helper'

def form_a_group
  users = []
    groups = []
    3.times do
      user = FactoryGirl.create(:user)
      group = user.assign_new_group
      users << user
      groups << group
    end
  [users, groups[0]]
end

describe Proposal do

  it {should_not be_valid}

  it 'current round is not over' do
    users, group = form_a_group
    p = create(:proposal, from: users[0].id, to: users[1].id, group_id: group.id)
    Proposal.current_round_is_over?(p.round_id, group.id).should be_false 
  end 

  it 'current round is over' do
    users, group = form_a_group
    p = create(:proposal, 
                from: users[0].id, 
                to: users[1].id, 
                group_id: group.id,
                round_id: group.round_id,
                accept: true)
    Proposal.current_round_is_over?(group.round_id, group.id).should be_true 
  end
  
  it 'submit a new proposal should be ok'  do
    users, group = form_a_group
    p = Proposal.submit_proposal(from: users[0].id,
                             to: users[1].id,
                             group_id: group.id,
                             round_id: group.round_id,
                             money_a: 120,
                             money_b: 200,
                             money_c: 300)
    p.should_not be_nil
    last_p = Proposal.last_proposal(from: users[0].id,
                           to: users[1].id,
                           group_id: group.id,
                           round_id: group.round_id)
    last_p.should_not be_nil

    last_p.id.should == p.id
    
  end

  it 'accept a proposal and round is over' do
    users, group = form_a_group
    proposal = Proposal.submit_proposal(from: users[0].id,
                             to: users[1].id,
                             group_id: group.id,
                             round_id: group.round_id,
                             money_a: 120,
                             money_b: 200,
                             money_c: 300)

    p = Proposal.accept_proposal(to: users[1].id,
                                 group_id: group.id,
                                 round_id: group.round_id,
                                 proposal_id: proposal.id)
    updated_g = Group.find(group.id)

    # group's round_id is updated
    updated_g.round_id.should_not eq(group.round_id)

    # old round is over, and new round is just started
    Proposal.current_round_is_over?(group.round_id, group.id).should be_true
    Proposal.current_round_is_over?(updated_g.round_id, updated_g.id).should be_false

  end

end