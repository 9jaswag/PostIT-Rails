module SessionsHelper

  # Log in a given user
  def log_in(user)
    session[:user_id] = user.id
  end

  # Find current user
  def current_user
    @current_user ||= User.find_by(id: session[:user_id])
  end

  # Return true if user is logged in or false if otherwise
  def logged_in?
    !current_user.nil?
  end
end
