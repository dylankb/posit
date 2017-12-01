class SessionController < ApplicationController
  def new
    @user = User.new
  end
  def create
    user = User.find_by(username: params[:username])
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      flash[:notice] = "You've logged in"
      redirect_to root_path
    else
      flash[:error] = "There was a problem with your username and/or password"
      redirect_to register_path
    end
  end

  def destroy
    session[:user_id] = nil
    flash[:notice] = "You're logged out"
    redirect_to root_path
  end
end
