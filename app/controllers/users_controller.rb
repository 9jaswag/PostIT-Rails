class UsersController < ApplicationController
  # before_action :logged_in_user, only: [:create]

  def index
    # @user = User.find(params[:username])
  end

  def show
    @user = User.find(params[:id])
  end    

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    # render plain: params[:user].inspect

    if @user.save
      log_in @user
      flash[:success] = "Signup successful! Welcome!"
      redirect_to @user
    else
      render 'index'
    end
  end

  private
    def user_params
      params.require(:user).permit(:username, :email, :phone, :password)
    end

    # confirm logged-in user
    def logged_in_user
      unless logged_in?
        flash[:danger] = "Please log in"
        redirect_to users_path
      end
    end

    # confirm correct user
    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless current_user?(@user)
    end
end
