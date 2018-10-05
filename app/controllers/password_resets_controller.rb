class PasswordResetsController < ApplicationController
  before_action :get_user,   only: %i[edit update]
  before_action :valid_user, only: %i[edit update]
  before_action :check_expiration, only: %i[edit update]
  def new; end

  def create
    @user = User.find_by(email: params[:password_reset][:email].downcase)
    if @user
      @user.create_reset_digest
      @user.send_password_reset_email
      flash[:success] = 'Check your email for password reset instructions.'
      redirect_to root_path
    else
      flash[:danger] = 'Email address not found'
      render 'new'
    end
  end

  def edit; end

  def update
    if params[:user][:password].empty?
      flash[:danger] = "Password can't be empty"
      render 'edit'
    elsif @user.update_attributes(user_params)
      @user.update(reset_digest: nil, reset_time: nil)
      log_in @user
      flash[:success] = 'Password has been reset.'
      redirect_to @user
    else
      render 'edit'
    end
  end

  private

  def get_user
    @user = User.find_by(email: params[:email])
  end

  # confirms a valid user
  def valid_user
    unless @user && @user.activated? && @user.authenticated?(:reset, params[:id])
      redirect_to root_path
    end
  end

  def check_expiration
    if @user.password_reset_expired?
      flash[:danger] = 'Password reset link has expired'
      redirect_to new_reset_path
    end
  end

  def user_params
    params.require(:user).permit(:password, :password_confirmation)
  end
end
