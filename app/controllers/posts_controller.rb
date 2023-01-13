class PostsController < ApplicationController
  before_action :set_post, only: %i[ show destroy ]
  before_action :authenticate_user

  def index
    @posts = Post.joins(:user).left_outer_joins(:comments).left_outer_joins(:likes).select("COUNT(comments.id) as comment_count, COUNT(likes.id) as like_count, Posts.created_at, Posts.id, Posts.picture_url, Posts.caption, users.username, users.profile_picture, users.id as user_id").where("users.id = ?", @current_user.id).group("posts.id, users.username, users.profile_picture, users.id")
    p @current_user
    render :json => @posts || { mes: "yee" }
  end

  def create
    @post = @current_user.posts.new(post_params)

    if @post.save
      render json: @post, status: :created
    else
      render json: @post.errors, status: :unprocessable_entity
    end
  end

  def show
    render :json => @post
  end

  def destroy
    if @post.destory
      render body: nil, status: :no_content
    else
      render json: @post.errors, status: :unprocessable_entity
    end
  end

  private

  def set_post
    @post = Post.find(params[:id])
  end

  def post_params
    params.require(:post).permit(:picture_url, :caption)
  end
end
