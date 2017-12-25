class UsersController < ApplicationController
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
      redirect_to @user
    else
      render 'index'
    end
  end

  private
    def user_params
      params.require(:user).permit(:username, :email, :phone, :password)
    end
end
