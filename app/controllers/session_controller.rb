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
      redirect_to root_url, :notice => "Welcome #{user.name}"
    else
      flash[:error] = "Invalid user name or password"
      render "new"
    end

  end

  def destroy
    cookies.delete(:auth_token)
    redirect_to root_url, :notice => "Logged out!"
  end
end
