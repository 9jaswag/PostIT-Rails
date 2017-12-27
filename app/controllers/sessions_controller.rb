class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(username: params[:session][:username_signin].downcase)
    if user && user.authenticate(params[:session][:password_signin])
      log_in user
      flash[:success] = "Signin successful! Welcome!"
      redirect_back_or user
    else
      flash[:danger] = 'Invalid email/password combination'
      redirect_to users_path      
    end
  end

  def destroy
    log_out
    redirect_to root_url
  end
end
