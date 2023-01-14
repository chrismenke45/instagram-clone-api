class CommentsController < ApplicationController
  before_action :set_post, only: %i[ index create ]
  before_action :authenticate_user

  def index
    @comments = @post.comments.joins(:user).select("Comments.text, Comments.id, Comments.created_at, Users.username, Users.id as user_id, Users.profile_picture").order("Comments.created_at DESC")
    render :json => @comments
  end

  def create
    @comment = @post.comments.new(comment_params)
    @comment.user_id = @current_user.id
    if @post.save
      render json: @comment, status: :created
    else
      render json: @comment.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @comment = Comment.find(params[:id])
    if @comment.destory
      render body: nil, status: :no_content
    else
      render json: @comment.errors, status: :unprocessable_entity
    end
  end

  private

  def set_post
    @post = Post.find(params[:post_id])
  end

  def comment_params
    params.require(:comment).permit(:text)
  end
end
