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
    @current_user ||= User.select(:id, :username, :email).find_by(id: session[:user_id])
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

  # confirm logged-in user
  def logged_in_user
    unless logged_in?
      store_location
      flash[:danger] = "Please log in or create an account"
      redirect_to users_path
    end
  end

  # confirm correct user
  def correct_user
    @user = User.find(params[:id])
    redirect_to(root_url) unless current_user?(@user)
  end

  # return to dashboard if user is not a group member
  def is_group_member(group_id)
    @group = Group.find(group_id)
    redirect_to(groups_path) unless current_user.groups.include?(@group)
    flash[:danger] = "You do not belong to that group" unless current_user.groups.include?(@group)
  end
end
