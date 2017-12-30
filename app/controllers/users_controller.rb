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
      log_in @user
      flash[:success] = "Signup successful! Welcome!"
      redirect_to @user
    else
      render 'index'
    end
  end

  def search
    @user = User.search(params[:username])
    respond_to do |format|
      format.json { render json: @user }
    end
  end

  private
    def user_params
      params.require(:user).permit(:username, :email, :phone, :password)
    end
end
