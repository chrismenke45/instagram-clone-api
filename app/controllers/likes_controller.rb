class LikesController < ApplicationController
  before_action :authenticate_user

  def index
    @likes = Like.joins(:user)
      .select("Users.username, Users.name, Users.profile_picture, Likes.user_id")
      .where("Likes.post_id = ?", params[:post_id])
    render :json => @likes
  end

  def create
    @like = Like.find_or_create_by(post_id: params[:post_id], user_id: @current_user.id)
    render :json => @like
    # if @like.save
    #   render :json => @like
    # else
    #   render json: @like.errors, status: :unprocessable_entity
    # end
    # #@like.user_id = current_user.id

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
