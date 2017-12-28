class MessagesController < ApplicationController
  def index
    @messages = Message.all    
  end

  def show
    @message = Message.find(params[:id])
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
end
