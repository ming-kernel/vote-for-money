require 'test_helper'

class UserTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end

  fixtures :users

  test 'user cannot be blank' do
    u = User.new
    assert u.invalid?, 'empty user should not allowed'
    assert u.errors[:name].any?
    assert u.errors[:password_digest].any?

  end

  test 'user name should be unique' do
    u = User.new(:name => 'one')
    assert u.invalid?, 'user name should be unique'
    assert u.errors[:name].any?

  end

  test 'assign group' do
    group = users(:one).assign_new_group
    assert_not_nil group.id, 'new group id should exists'
    assert users(:one).group_id == group.id, 'new group id should be in user'
  end


end
