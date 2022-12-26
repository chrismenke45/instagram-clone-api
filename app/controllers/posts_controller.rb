class PostsController < ApplicationController
  before_action :set_post, only: %i[ show destroy ]

  def index
    @posts = post.order(created_at: :desc).limit(10)
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
      render json: { message: "Post deleted" }
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
