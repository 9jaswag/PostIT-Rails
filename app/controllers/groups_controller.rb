class GroupsController < ApplicationController
  before_action :logged_in_user
  
  def index
    @groups = current_user.groups.paginate(page: params[:page], per_page: 2)
  end

  def show
    is_group_member(params[:id])
    @group = Group.find(params[:id])
    @messages = @group.messages.paginate(page: params[:page], per_page: 2)
  rescue StandardError
    flash[:danger] = "Group does not exist"
    redirect_to groups_path
    return
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
      return
    else
      render 'new'
    end
  end

  def search
    # use joins here later
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
    if is_group_owner(params[:group_id])
      member = group_member(params[:user_id], params[:group_id])
      if member.exists?
        if member[0].group[:owner] == member[0].user[:username] # if group owner is trying to remove self
          @message = "Why you wanna do like that? You can't leave your group"
        else
          if member.destroy(member[0].id)
            @message = "User has been removed from group"
            puts @message
            respond_to do |format|
              format.js
            end
          else
            render 'show'
          end
        end
      else
        render 'show'
      end
    else
      @message = "Why you wanna do like that? It's not your group"
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
