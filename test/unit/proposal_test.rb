require 'test_helper'

class ProposalTest < ActiveSupport::TestCase
  fixtures :proposals

  test 'proposal null' do
    p = Proposal.new
    assert p.invalid?
  end

  test 'current round is over' do
    assert Proposal.current_round_is_over?(1, 0)

  end

  test 'no last proposal' do
    assert !Proposal.last_proposal(from: 1, group_id: 1, round_id: 0)
  end

  test 'current round is not over' do
    assert !Proposal.current_round_is_over?(1, 1)
  end

  test 'has last proposal' do
    assert Proposal.last_proposal(from: 1, group_id: 1, round_id: 1)
  end

  test 'submit a new proposal to round 1' do
    p = Proposal.submit_proposal(from: 1, to: 2, group_id: 1, round_id: 1,
                                 money_a: 100, money_b: 200, money_c: 300)
    assert p, 'new proposal saved'
  end

  test 'submit a new proposal and get last proposal' do
    p = Proposal.submit_proposal(from: 1, to: 2, group_id: 1, round_id: 1,
                                 money_a: 120, money_b: 200, money_c: 300)
    assert p, 'new proposal saved'
    last = Proposal.last_proposal(from: 1, group_id: 1, round_id: 1)

    assert p.id == last.id, 'last proposal is new'
  end

  test 'accept a proposal' do
    p = Proposal.accept_proposal(group_id: 1, round_id: 1, proposal_id: 3)
    assert p, 'proposal accepted'

    assert Proposal.current_round_is_over?(1, 1), 'current round is over'


  end



end
