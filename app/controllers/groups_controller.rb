class GroupsController < ApplicationController
  before_action :logged_in_user
  def index
    @groups = Group.all
  end

  def show
    @group = Group.find(params[:id])
  end

  def new
    @group = Group.new
  end

  def create
    @group = Group.new(group_params)
    @group[:owner] = current_user.username
    @group.group_members.build(user_id: current_user.id)

    if @group.save
      flash[:success] = "Group created successfully"
      redirect_to @group
    else
      render 'new'
    end
  end

  def search
    @users = User.search(params[:username])
    respond_to do |format|
      format.js
    end
  end

  def add_member
    group_member = GroupMember.new(group_member_params)
    
    if group_member.save
      flash[:success] = "User added successfully"
    else
      render 'show'
    end
  end

  private
    def group_params
      params.require(:group).permit(:name, :description)
    end

    def group_member_params
      params.permit(:group_id, :user_id)
    end
end
