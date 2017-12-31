class GroupsController < ApplicationController
  before_action :logged_in_user
  def index
    @groups = current_user.groups
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
    users = User.search(params[:username])
    @users = []
    users.each do |user|
      member = group_member(user.id, params[:group_id])
      if member.exists?
        @users << { user: user, is_member: true}
      else
        @users << { user: user, is_member: false}
      end
    end

    respond_to do |format|
      format.js
    end
  end

  def add_member
    member = group_member(params[:user_id], params[:group_id])
    if member.exists?
      @message = "User is already a group member"
      respond_to do |format|
        format.js
      end
    else
      group_member = GroupMember.new(group_member_params)
      
      if group_member.save
        @message = "User has been added to group"
        respond_to do |format|
          format.js
        end
      else
        render 'show'
      end
    end
  end

  def remove_member
    member = group_member(params[:user_id], params[:group_id])
    if member.exists?
      if member.destroy(member[0].id)
        @message = "User has been removed from group"
        puts @message
        respond_to do |format|
          format.js
        end
      else
        render 'show'
      end
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

    # returns a group member
    def group_member(user_id, group_id)
      member = GroupMember.where(user_id: user_id, group_id: group_id)
    end
end
