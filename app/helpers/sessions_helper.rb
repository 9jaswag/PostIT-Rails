module SessionsHelper

  # Log in a given user
  def log_in(user)
    session[:user_id] = user.id
  end

  # Returns true if given user is the current user
  def current_user? (user)
    user == current_user
  end

  # Find current user
  def current_user
    @current_user ||= User.find_by(id: session[:user_id])
  end

  # Return true if user is logged in or false if otherwise
  def logged_in?
    !current_user.nil?
  end

  # Log out current user
  def log_out
    session.delete(:user_id)
    @current_user = nil
  end

  # Redirect to a stored location or to the default
  def redirect_back_or(default)
    redirect_to(session[:forwarding_url] || default)
    session.delete(:forwarding_url)
  end

  # Stores the URL trying to be accessed
  def store_location
    session[:forwarding_url] = request.original_url if request.get?
  end
end
