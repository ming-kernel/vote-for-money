class Admin < ActiveRecord::Base
  attr_accessible :stop
  def self.game_is_over
    admin = Admin.all[0]
    admin.stop
  end
end
