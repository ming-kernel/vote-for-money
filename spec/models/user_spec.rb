require 'spec_helper'
describe User do
  
  it { should_not be_valid }

  it "should be valid" do
    user = build(:user)
    user.should be_valid
  end

  it "should not be valid when password_confirmation is nil" do
    user = build(:user, password_confirmation: nil)
    user.should_not be_valid
  end

  it "should not be valid when password_confiramtion != password" do
    user = build(:user, password_confirmation: 'random')
    user.should_not be_valid
  end

  it "class should respond to authenticate" do
    User.should respond_to(:authenticate)
  end

  it "instance should respond to authnticate" do
    user = build(:user)
    user.should respond_to(:authenticate)
  end

  it "with valid password" do
    user = create(:user)
    User.authenticate(user.name, 'private').should eq(user)
  end

  it "with invalid password" do
    user = create(:user)
    User.authenticate('u', 'invalid').should be_nil
  end


  it "assign new group ok" do
    user = build(:user)
    group = user.assign_new_group
    group.id.should eq(user.group_id)
  end

  it "three users form a group" do
    users = []
    groups = []
    3.times do
      user = create(:user)
      group = user.assign_new_group
      users << user
      groups << group
    end

    g0 = groups[0]
    3.times do |i|
      g0.should eq(groups[i])
    end
  end
  
end