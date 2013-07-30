class SessionController < ApplicationController
  def new
    if current_user
      redirect_to root_url
    end
  end

  # /login
  def create
    user = User.find_by_name(params[:name])
    if user && user.authenticate(params[:password])
      if params[:remember_me] == "on"
        cookies.permanent[:auth_token] = user.auth_token
      else
        cookies[:auth_token] = { :value => user.auth_token, 
                                :expires => 20.hours.from_now }
      end
      redirect_to root_url, :notice => 'Logged in'
    else
      flash[:error] = "Invalid user name or password"
      render "new"
    end

    # user = User.authenticate(login_params[:username], login_params[:password])
    # if user
    #   session[:user_id] = user.id
    #   session[:group_id] = user.group_id
    #   session[:user_name] = user.name
    #   session[:round_id] = user.group.round_id

    #   flash[:notice] = 'Welcome to the game'
    #   #redirect_to :action => session[:intended_action],
    #   #            :controller => session[:intended_controller]
    #   redirect_to game_url

    # else
    #   flash[:notice] = 'Invalid username or password'
    #   redirect_to login_url, error: 'Invalid username or password'
    # end
  end

  def destroy
    cookies.delete(:auth_token)
    redirect_to root_url, :notice => "Logged out!"
  end
end
