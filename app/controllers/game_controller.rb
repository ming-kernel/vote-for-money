class GameController < ApplicationController
  def index
    unless current_user
      redirect_to login_url, notice: "You need to login in"
      return false
    end

    session[:group_id] = current_user.group_id
    # session[:user_id] = current_user.id
    # if (!session[:group_id])
    #   redirect_to root_url, notice: "Admin haven't signed you a group, please wait"
    # end
  end

  def get_group_info
    if current_user
      group_info = User.get_group_info(current_user.id, current_user.group_id)
      respond_to do |format|
        format.json { render json: group_info }
      end

    else
      respond_to do |format|
        format.json { render json: nil }
      end
    end

  end

end
