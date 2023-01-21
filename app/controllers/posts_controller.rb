class PostsController < ApplicationController
  before_action :set_post, only: %i[ show destroy ]
  before_action :authenticate_user

  def index
    if params[:user]
      whereStatement = "users.id = #{params[:user]}"
    else
      whereStatement = "users.id IS NOT NULL"
    end
    if params[:preview]
      @posts = Post.joins(:user)
        .select("Posts.id, Posts.picture_url")
        .where(whereStatement)
        .group("posts.id, users.username, users.profile_picture, users.id")
        .order("posts.created_at DESC")
    else
      @posts = Post.joins(:user).left_outer_joins(:comments).left_outer_joins(:likes)
        .select("COUNT(DISTINCT comments.id) as comment_count, COUNT(DISTINCT likes.user_id) as like_count, CAST(CAST(SUM(DISTINCT CASE WHEN Likes.user_id = #{@current_user.id} THEN 1 ELSE 0 END) AS INT) AS BOOLEAN) as current_user_liked")
        .select("Posts.created_at, Posts.caption, Posts.id, Posts.picture_url, Posts.caption, users.username, users.profile_picture, users.id as user_id")
        .where(whereStatement)
        .group("posts.id, users.username, users.profile_picture, users.id")
        .order("posts.created_at DESC")
    end
    render :json => @posts
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
