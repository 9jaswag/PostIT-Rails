class UsersController < ApplicationController
  before_action :logged_in_user, only: [:show]

  def index
    # @user = User.find(params[:username])
  end

  def show
    @user = User.find(params[:id])
    redirect_to root_path unless @user.activated?
  rescue StandardError => e
    flash[:danger] = "User does not exist"
    redirect_to root_path
  end    

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    # render plain: params[:user].inspect

    if @user.save
      @user.send_activation_mail
      flash[:success] = "Thanks for signing up. Check your email to activate your account"
      # clear cookie just in case
      log_out
      redirect_to root_path
    else
      render 'index'
    end
  end

  private
    def user_params
      params.require(:user).permit(:username, :email, :phone, :password)
    end
end
