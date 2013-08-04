class UsersController < ApplicationController

  # GET /users/new
  # GET /users/new.json
  def new
    @user = User.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @user }
    end
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(params[:user])
    @user.last_active = Time.now
    @user.round_id = 0
    @user.earnings = 0
    respond_to do |format|
      if @user.save!
        set_auth_token(@user)
        format.html {
          session[:user_id] = @user.id
          session[:user_name] = @user.name
          session[:group_id] = nil
          session[:round_id] = nil
          redirect_to root_url, notice: "Welcome #{@user.name}"
        }
        format.json { render json: @user, status: :created, location: @user }
      else
        # format.html { render action: "new" }
        format.html { redirect_to new_user_url, :notice => "Save failed" }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /users/1
  # PUT /users/1.json
  def update
    @user = User.find(params[:id])

    respond_to do |format|
      if @user.update_attributes(params[:user])
        format.html { redirect_to users_url, notice: 'User was successfully updated.' }

        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user = User.find(params[:id])
    @user.destroy

    respond_to do |format|
      format.html { redirect_to users_url }
      format.json { head :no_content }
    end
  end

  # POST /users/next-round.json
  def next_round
    user_id = params[:user_id].to_i
    u = User.find(user_id)
    u.round_id = u.group.round_id
    session[:round_id] = u.round_id
    respond_to do |format|
      if u.save
        format.json { render json: u }
      else
        format.json { render json: nil }
      end
      
    end
  end
end
