class SessionController < ApplicationController
  def new
    if session[:user_id]
      redirect_to '/'
    end

  end

  # /login
  def create
    user = User.authenticate(params[:username], params[:password])
    if user
      session[:user_id] = user.id
      session[:group_id] = user.group_id
      session[:user_name] = user.name
      session[:round_id] = user.group.round_id

      flash[:notice] = 'Welcome to the game'
      #redirect_to :action => session[:intended_action],
      #            :controller => session[:intended_controller]
      redirect_to game_url

    else
      flash[:notice] = 'Invalid username or password'
      redirect_to login_url, error: 'Invalid username or password'
    end
  end

  def destroy
    session[:user_id] = nil
    session[:group_id] = nil
    session[:user_name] = nil
    session[:round_id] = nil
    redirect_to '/', :notice => 'Logged out'
  end
end
