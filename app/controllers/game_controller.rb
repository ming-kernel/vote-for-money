class GameController < ApplicationController
  def index
    unless current_user
      redirect_to login_url, notice: "You need to login in"
    end
    # unless session[:user_id]
    #   session[:intended_action] = action_name
    #   session[:intended_controller] = controller_name
    #   redirect_to login_url
    # end

  end

  def get_group_info

    group_info = User.get_group_info(session[:user_id], session[:group_id])
    respond_to do |format|
      format.json { render json: group_info }
    end

  end

  def do_something
    render :text => params
  end

end
