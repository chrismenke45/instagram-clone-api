class MessagesController < ApplicationController
  before_action :authenticate_user

  def index
    @messages = Message.all
    render :json => @messages
  end

  def create
    @message = Message.new(message_params)
    @message.sender_id = @current_user.id
    if @message.save
      render json: @message, status: :created
    else
      render json: @message.errors, status: :unprocessable_entity
    end
  end

  def show
    @message.where("sender_id = ?", params[:sender_id])
    render :json => @message
  end

  private

  def message_params
    params.require(:message).permit(:text, :receiver_id)
  end
end
