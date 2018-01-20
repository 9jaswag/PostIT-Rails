class MessagesController < ApplicationController
  before_action :logged_in_user

  def index
    @messages = Message.all    
  end

  def show
    is_group_member(params[:group_id])
    # confirm if message belongs to group
    # Group.joins(:messages).where('group_id = ?, messages.id =?', 2, 2)
    @message = Message.find(params[:id])
    unless Group.find(params[:group_id]).messages.include?(@message)
      flash[:danger] = "Message does not exist"
      return
    end
  rescue StandardError
    flash[:danger] = "Message does not exist"
    redirect_to group_path(params[:group_id])
    return
  end

  def new
    @message = Message.new
  end

  def create
    @message = current_user.messages.new(message_params)
    @message[:readby] << current_user.username
    @message[:group_id] = params[:group_id]
    respond_to do |format|
      if @message.save
        send_notification(@message) unless @message.priority == "normal"
        flash[:success] = 'Message was successfully created.'
        format.html { redirect_to group_message_path(id: @message[:id]) }
      else
        format.html { render action: "new" }
      end
    end
  end
  
  private
    def message_params
      params.require(:message).permit(:title, :body, :priority, :readby)
    end

    def send_notification(message)
      groupMembers = Group.find(params[:group_id]).users
      groupMembers.each do |member|
        unless member.email == message.user.email
          UserMailer.email_notification(member, message).deliver_now
        end
      end
    end
end
