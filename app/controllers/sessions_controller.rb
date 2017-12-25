class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(username: params[:session][:username_signin].downcase)
    if user && user.authenticate(params[:session][:password_signin])
      redirect_to user_path(user[:id])
    else
      flash[:danger] = 'Invalid email/password combination'
      redirect_to users_path      
    end
  end

  def destroy
  end
end
