class ApplicationController < ActionController::Base
  protect_from_forgery

  def set_auth_token(user)
    cookies[:auth_token] = user.auth_token
  end

  private
  
  def current_user
    @current_user ||= User.find_by_auth_token( cookies[:auth_token]) if cookies[:auth_token]
  end

  helper_method :current_user
end
