module SessionsHelper
  
  # Log in a given user
  def log_in(user)
    session[:user_id] = user.id
  end
end
