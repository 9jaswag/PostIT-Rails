class AccountActivationsController < ApplicationController
  def edit
    user = User.find_by(email: params[:email])
    if user && !user.activated? && user.authenticated?(:activation, params[:id])
      user.update_attribute(:activated, true)
      user.update_attribute(:activated_time, Time.zone.now)
      log_in user
      flash[:success] = "Account activated! Welcome to PostIT"
      redirect_to groups_path
    else
      flash[:danger] = "Invalid activation link"
      redirect_to root_path
    end
  end
end
