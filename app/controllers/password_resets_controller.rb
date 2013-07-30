class PasswordResetsController < ApplicationController
  def new
  end

  def create 
    email = params[:reset_email][:email]
    user = User.find_by_email(email)
    user.send_password_reset if user
    redirect_to root_url, :notice => "Plese check your email to reset your password."
  end

  def edit
    @user = User.find_by_password_reset_token!(params[:id])
  end

  def update
    @user = User.find_by_password_reset_token!(params[:id])
    if @user.password_reset_sent_at < 2.hours.ago
      redirect_to new_password_reset_path, :alert => "Password &crarr; 
        reset has expired."
    elsif @user.update_attributes(params[:user])
      redirect_to root_url, :notice => "Password has been reset."
    else
      render :edit
    end
  end
end
