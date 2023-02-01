class FollowsController < ApplicationController
  before_action :authenticate_user
  before_action :find_current_user_followings, only: [:index]

  def index
    if params[:following]
      @follows = Follow.joins("INNER JOIN users ON follows.followee_id = users.id")
        .select("users.username, users.name, users.profile_picture, follows.followee_id as user_id, CAST(CAST(SUM(DISTINCT CASE WHEN follows.followee_id IN (#{@current_user_followings.join(", ")}) THEN 1 ELSE 0 END) AS INT) AS BOOLEAN) as current_user_follows")
        .where("follower_id = ?", params[:user_id])
        .group("follows.followee_id, users.username, Users.name, Users.profile_picture")
    else
      @follows = Follow.joins("INNER JOIN users ON follows.follower_id = users.id")
        .select("users.username, users.name, users.profile_picture, follows.follower_id as user_id, CAST(CAST(SUM(DISTINCT CASE WHEN follows.follower_id IN (#{@current_user_followings.join(", ")}) THEN 1 ELSE 0 END) AS INT) AS BOOLEAN) as current_user_follows")
        .where("followee_id = ?", params[:user_id])
        .group("follows.follower_id, users.username, Users.name, Users.profile_picture")
    end
    render :json => @follows || []
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
      render :json => { error: "Follow could not be destroyed" }, status: :conflict
    end
  end
end
