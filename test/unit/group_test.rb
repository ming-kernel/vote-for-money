require 'test_helper'

class GroupTest < ActiveSupport::TestCase

  test 'group null' do
    g = Group.new
    assert g.invalid?, 'group should not null'

  end

  test 'group without user' do
    g = Group.new(round_id: 0)
    assert g.invalid?, 'group without user'
  end

  test 'group without round id' do
    g = Group.new(users_number: 1)
    assert g.invalid?, 'group without round id'
  end

  test 'group with user' do
    g = Group.new(users_number: 1, round_id: 0)
    assert g.valid?
  end


end
