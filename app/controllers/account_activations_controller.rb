class AccountActivationsController < ApplicationController
  def edit
    user = User.find_by(email: params[:email])
    if user && !user.activated? && user.authenticated?(:activation, params[:id])
      user.activate
      log_in user
      flash[:success] = 'Account activated! Welcome to PostIT'
      redirect_to groups_path
    else
      flash[:danger] = 'Invalid activation link'
      redirect_to root_path
    end
  end
end
