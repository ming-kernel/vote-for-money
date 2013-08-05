class AdminController < ApplicationController
  def index 

  end

  def show_users
    users = User.all
    respond_to do |format|
      format.json { 
        render json: users
      }
    end
  end

  def show_groups
    groups = Group.all
    respond_to do |format|
      format.json { 
        render json: groups
      }
    end
  end

  def show_proposals
    proposals = Proposal.all
    respond_to do |format|
      format.json { 
        render json: proposals
      }
    end
  end

  def assign_users
    # 1) randomly pick out users which has not been assigned to a group
    # 2) randomly pick out goups which is not full, if any
    users = User.all.find_all {|u| u.group_id == nil}
    users.shuffle!
    while users.length >= 3 do
      group_users = users.slice!(0, 3)
      assign_users_to_new_group(group_users)
    end

    if users.length  == 0
      notice_msg = 'all users are ready'
    else
      notice_msg = "#{users.length} users not assigned to any group"
    end
    redirect_to admin_url, :notice => notice_msg
  end

  def delete_users
    User.delete_all("name != 'admin'")
    Group.delete_all()
    Proposal.delete_all()
    redirect_to admin_url, :notice => 'All users, groups and proposals deleted'
  end

private
  # group_users should be a three element array
  # each user should have a group_id = nil
  def assign_users_to_new_group(group_users)
    group = Group.new
    group.users_number = 3
    group.round_id = 0
    group.save!

    group_users.each do |u|
      u.round_id = 0
      u.group_id = group.id
      u.save!
    end
  end


  def assign_user_to_group

  end

end
