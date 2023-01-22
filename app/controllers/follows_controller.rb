class FollowsController < ApplicationController
  before_action :authenticate_user

  def index
    @follows = Follow.all
    render :json => @likes
  end

  def create
    @follow = Follow.find_or_initialize_by(followee_id: params[:user_id], follower_id: @current_user.id)
    if @follow.save
      render :json => @follow
    else
      render json: @follow.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @follow = Follow.find_by(followee_id: params[:user_id], follower_id: @current_user.id)
    if @follow.destroy
      render :json => { message: "Follow Destroyed" }
    else
      render :json => { error: "Follow could not be destroyed" }, status: :unprocessable_entity
    end
  end
end
