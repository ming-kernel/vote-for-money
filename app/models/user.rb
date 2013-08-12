class User < ActiveRecord::Base
  belongs_to :group
  attr_accessible :name, :password, :password_confirmation, :round_id, :last_active, :earnings

  validates_presence_of :password, :on => :create
  validates_presence_of :password_confirmation, :on => :create
  validates_presence_of :name, :on => :create
  # validates :name, :password, :password_confirmation, presence: true

  validates :name, :uniqueness =>  true



  has_secure_password

  before_create { generate_token(:auth_token) }

  def generate_token(column)
    begin
      self[column] = SecureRandom.urlsafe_base64
    end while User.exists?(column => self[column])
  end

  def send_password_reset
    generate_token(:password_reset_token)
    self.password_reset_sent_at = Time.zone.now
    save!
    UserMailer.password_reset(self).deliver
  end

  def assign_new_group

    groups = Group.where('users_number < ?', 3)
    puts 'done with query'
    if groups == []
      new_group = Group.new(users_number: 1, round_id: 0)
    else
      new_group = groups[0]
      new_group.users_number += 1
    end

    unless new_group.save
      raise 'Group creation failed'
    end

    self.group_id = new_group.id
    new_group
  end

  def user_is_active
    (Time.now - self.last_active) <= 10
  end

  def self.get_group_info(user_id, group_id)
    if !user_id || !group_id
      return nil
    end

    begin
      round_id = User.find(user_id).round_id
    rescue
      puts 'user not found maybe because test case delete it first'
      return nil
    end

    update_last_active(user_id)
    group = Group.find(group_id)
    users = group.users
    group_info = {}
    group_info['stop'] = false
    group_info['round_id'] = group.round_id
    group_info['betray_penalty'] = group.betray_penalty;
    group_info['self'] = {}
    group_info['opponents'] = [{}, {}]
    group_info['round_decision'] = nil

    if (Admin.game_is_over)
      group_info['stop'] = true
      # return group_info
    end

    o_idx = 0
    users.each do |u|

      #indicate self or not
      if user_id == u.id
        group_info['self']['user_name'] = u.name
        group_info['self']['user_id'] = u.id
        group_info['self']['earnings'] = u.earnings
        group_info['self']['round_id'] = u.round_id

        if u.user_is_active
          group_info['self']['online'] = true
        else
          group_info['self']['online'] = false
        end

        #proposals that I proposal to others
        #group_info['self']['proposal'] = Proposal.last_proposal(from: user_id,
        #                                                        group_id: group_id,
        #                                                        round_id: round_id)
      else
        group_info['opponents'][o_idx]['user_name'] = u.name
        group_info['opponents'][o_idx]['user_id'] = u.id
        group_info['opponents'][o_idx]['earnings'] = u.earnings
        group_info['opponents'][o_idx]['round_id'] = u.round_id

        if u.user_is_active
          group_info['opponents'][o_idx]['online'] = true
        else
          group_info['opponents'][o_idx]['online'] = false
        end

        # proposals others proposal to me
        group_info['opponents'][o_idx]['proposal'] = Proposal.last_proposal(from: u.id,
                                                                            to: user_id,
                                                                            group_id: group_id,
                                                                            round_id: round_id)
        o_idx += 1
      end

    end
    round_decision = Proposal.current_decision(round_id, group_id)
    last_round_decision = Proposal.last_round_decision(round_id, group_id)
    group_info['round_decision'] =  round_decision
    group_info['last_round_decision'] = last_round_decision
    puts '='*30
    puts round_id
    puts round_decision
    puts '='*30
    group_info
  end

  def self.update_last_active(user_id)
    puts "update_last_active: user_id: #{user_id}"
    
    User.update(user_id, last_active: Time.now)
    # user = User.find(user_id)
    # user.last_active = Time.now
    # user.save!
    # unless user.save
    #   raise 'update_last_active error'
    # end
  end

  def self.authenticate(name, password)

    user = User.find_by_name(name)


    unless user && user.authenticate(password)
      return nil
    end

    if user.group_id == nil
      group = user.assign_new_group
      user.group_id = group.id
    end
    user
  end
end
