class PostsController < ApplicationController
  before_action :set_post, only: %i[destroy]
  before_action :authenticate_user
  before_action :find_current_user_followings, only: %i[index]

  def index
    if params[:user]
      #posts for a specific user's profile
      whereStatement = "users.id = #{params[:user]}"
    elsif params[:discover]
      whereStatement = "users.id IS NOT NULL"
    elsif params[:search]
      search = params[:search].downcase
      whereStatement = "LOWER(posts.caption) LIKE '%#{search}%' OR LOWER(users.username) LIKE '#{search}%' OR LOWER(users.name) LIKE '#{search}%'"
    else
      #posts for a users feed
      whereStatement = "users.id IN (#{@current_user_followings.push(@current_user.id).join(", ")})"
    end
    groupStatement = "posts.id, users.username, users.profile_picture, users.id"
    orderStatement = "posts.created_at DESC"
    limitStatement = params[:count] || 15
    if params[:preview]
      @posts = Post.joins(:user)
        .select("Posts.id, Posts.picture_url")
        .where(whereStatement)
        .group(groupStatement)
        .order(orderStatement)
        .limit(limitStatement)
    else
      @posts = Post.joins(:user).left_outer_joins(:comments).left_outer_joins(:likes)
        .select("COUNT(DISTINCT comments.id) as comment_count, COUNT(DISTINCT likes.user_id) as like_count, CAST(CAST(SUM(DISTINCT CASE WHEN Likes.user_id = #{@current_user.id} THEN 1 ELSE 0 END) AS INT) AS BOOLEAN) as current_user_liked")
        .select("Posts.created_at, Posts.caption, Posts.id, Posts.picture_url, Posts.caption, users.username, users.profile_picture, users.id as user_id")
        .where(whereStatement)
        .group(groupStatement)
        .order(orderStatement)
        .limit(limitStatement)
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
    @post = Post.joins(:user).left_outer_joins(:comments).left_outer_joins(:likes)
      .select("COUNT(DISTINCT comments.id) as comment_count, COUNT(DISTINCT likes.user_id) as like_count, CAST(CAST(SUM(DISTINCT CASE WHEN Likes.user_id = #{@current_user.id} THEN 1 ELSE 0 END) AS INT) AS BOOLEAN) as current_user_liked")
      .select("Posts.created_at, Posts.caption, Posts.id, Posts.picture_url, Posts.caption, users.username, users.profile_picture, users.id as user_id")
      .where("posts.id = ?", params[:id])
      .group("posts.id, users.username, users.profile_picture, users.id")
    render :json => @post
  end

  def destroy
    if @post.user_id != @current_user.id
      render json: { message: "you can't delete someone else's post" }, status: 401
    elsif @post.destroy
      render json: { message: "post deleted" }, status: 200
    else
      render json: @post.errors, status: :conflict
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
