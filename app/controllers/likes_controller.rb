class LikesController < ApplicationController
  def index
    @likes = Like.joins(:user).select("user.username, user.name, post.user_id").where("like.post_id = ?", params[:post_id])
    render :json => @likes
  end

  def create
    @like = Like.new(post_id: params[:post_id])
    @like.user_id = @current_user.id
    if @like.save
      render :json => @like
    else
      render json: @like.errors, status: :unprocessable_entity
    end
    #@like.user_id = current_user.id

  end

  def destroy
    @like = Like.find_by(post_id: params[:post_id], user_id: @current_user.id)
    if @like.destory
      render :json => { message: "Like Destroyed" }
    else
      render :json => { error: "Like could not be destroyed" }, status: :unprocessable_entity
    end
  end
end
