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

  private
    def group_params
      params.require(:group).permit(:name, :description)
    end
end
