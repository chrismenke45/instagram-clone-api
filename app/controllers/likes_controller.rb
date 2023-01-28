class LikesController < ApplicationController
  before_action :authenticate_user
  before_action :find_current_user_followings, only: [:index]

  def index
    @likes = Like.joins(:user)
      .select("Users.username, Users.name, Users.profile_picture, Likes.user_id, CAST(CAST(SUM(DISTINCT CASE WHEN Users.id IN (#{@current_user_followings.join(", ")}) THEN 1 ELSE 0 END) AS INT) AS BOOLEAN) as current_user_follows")
      .where("Likes.post_id = ?", params[:post_id])
      .group("likes.user_id, users.username, Users.name, Users.profile_picture")
    render :json => @likes
  end

  def create
    @like = Like.find_or_create_by(post_id: params[:post_id], user_id: @current_user.id)
    render :json => @like
  end

  def destroy
    @like = Like.find_by(post_id: params[:post_id], user_id: @current_user.id)
    if @like.destroy
      render :json => { message: "Like Destroyed" }
    else
      render :json => { error: "Like could not be destroyed" }, status: :unprocessable_entity
    end
  end
end
