require 'spec_helper'
describe Group  do
  it { should_not be_valid }

  it "group without user should not be valid" do
    g = build(:group, users_number: 0)
    g.should_not be_valid    
  end

  it "gorup without round id should not be valid" do
    g = build(:group, round_id: nil)
    g.should_not be_valid
  end

  it "group with user and round id should be valid" do
    g = build(:group)
    g.should be_valid
  end

  it "group with 0 users_number should be invalid" do
    g = build(:group, round_id: 0, users_number: 0)
    g.should_not be_valid
  end


end