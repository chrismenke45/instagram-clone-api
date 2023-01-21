class FollowsController < ApplicationController
  def index
    @follows = Follow.all
    render :json => @likes
  end

  def create
    @follow = Follow.find_or_create_by(followee_id: params[:user_id], follower_id: @current_user.id)
    render :json => @like
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
