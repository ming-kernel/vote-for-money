class Decision < ActiveRecord::Base
  attr_accessible :choice, :proposal_id, :user_id
end
