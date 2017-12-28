class MessagesController < ApplicationController
  def index
    @messages = Message.all    
  end

  def new
    @message = Message.new
  end

  def create
    @message = Message.new(message_params)
    render plain: params
    # respond_to do |format|
    #   if @message.save
    #     flash[:notice] = 'Message was successfully created.'
    #     format.html { redirect_to(@message) }
    #     format.xml { render xml: @message, status: :created, location: @message }
    #   else
    #     format.html { render action: "new" }
    #     format.xml { render xml: @message.errors, status: :unprocessable_entity }
    #   end
    # end
  end
  
  private
    def message_params
      params.require(:message).permit(:title, :body, :priority, :readby)
    end
end
