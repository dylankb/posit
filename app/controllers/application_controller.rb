class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  helper_method :current_user, :logged_in?

  def current_user
    # Use ||= as memoization technique to avoid hitting the database each time a view needs to call method
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def logged_in?
    !!current_user
  end

  def access_denied(message)
    flash[:error] = message
    redirect_to root_path
  end

  def require_user
    permission_error = 'You must be logged in to do that'
    access_denied(permission_error) unless logged_in?
  end

  def require_admin
    permission_error = 'You must be an admin to do that'
    access_denied(permission_error) unless current_user.admin?
  end

  def require_admin_or_creator
    current_user.admin?
  end
end
