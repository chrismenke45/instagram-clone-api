class MessagesController < ApplicationController
  before_action :authenticate_user

  def index
    #need inner select statement to find MAX created at messages by each user and then use those id's in this where statement
    @most_recent_messages_by_each_user_with_user_id = Message.select("MAX(id) AS id")
      .select("CASE WHEN messages.receiver_id = #{@current_user.id} THEN messages.sender_id ELSE messages.receiver_id END AS user_id")
      .where("messages.sender_id = :current_user OR messages.receiver_id = :current_user", { current_user: @current_user.id })
      .group("user_id").to_sql

    p @most_recent_messages_by_each_user
    #@most_recent_messages_by_each_user_without_user_id = Message.find_by_sql("SELECT id from (#{@most_recent_messages_by_each_user_with_user_id}) AS message_id_with_user_id").to_sql
    @most_recent_messages_by_each_user_without_user_id = "SELECT id from (#{@most_recent_messages_by_each_user_with_user_id}) AS message_id_with_user_id"
    p @most_recent_messages_by_each_user_without_user_id
    p "***********************"
    p "__________________________"
    # @messages = Message.joins("JOIN users AS senders ON messages.sender_id = senders.id").joins("JOIN users AS receivers ON messages.receiver_id = receivers.id")
    #   .select("messages.id, messages.created_at, messages.text")
    #   .select("CASE WHEN messages.receiver_id = #{@current_user.id} THEN messages.sender_id ELSE messages.receiver_id END AS user_id")
    #   .select("CASE WHEN messages.sender_id = #{@current_user.id} THEN receivers.profile_picture ELSE senders.profile_picture END")
    #   .select("CASE WHEN messages.sender_id = #{@current_user.id} THEN receivers.username ELSE senders.username END")
    #   .where("messages.sender_id = :current_user OR messages.receiver_id = :current_user", { current_user: @current_user.id })
    @messages = Message.joins("JOIN users AS senders ON messages.sender_id = senders.id").joins("JOIN users AS receivers ON messages.receiver_id = receivers.id")
      .select("messages.id, messages.created_at, messages.text")
      .select("CASE WHEN messages.receiver_id = #{@current_user.id} THEN messages.sender_id ELSE messages.receiver_id END AS user_id")
      .select("CASE WHEN messages.sender_id = #{@current_user.id} THEN receivers.profile_picture ELSE senders.profile_picture END")
      .select("CASE WHEN messages.sender_id = #{@current_user.id} THEN receivers.username ELSE senders.username END")
      .where("messages.id IN (#{@most_recent_messages_by_each_user_without_user_id})")
      .order("messages.created_at DESC")
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
    @message.where("sender_id = :current_user AND receiver_id = :other_user OR sender_id = :other_user AND receiver_id = :current_user", { current_user: @current_user.id, other_user: params[:sender_id] })
    render :json => @message
  end

  private

  def message_params
    params.require(:message).permit(:text, :receiver_id)
  end
end
