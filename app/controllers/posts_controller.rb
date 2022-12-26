class PostsController < ApplicationController
  before_action :set_post, only: %i[ show destroy ]

  def index
    #@posts = Post.joins(:comments).group("post.id").select("COUNT(comments) as Comment_count, created_at, id, picture_url, caption").order(created_at: :desc).limit(10)
    @posts = Post.left_outer_joins(:comments).select("COUNT(comments.id) as Comment_count, Posts.created_at, Posts.id, Posts.picture_url, Posts.caption").group("posts.id")
    render :json => @posts
  end

  def create
    @post = Post.new(post_params)
    #@post = User.posts.new(post_params)

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
