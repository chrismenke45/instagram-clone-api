class CommentsController < ApplicationController
  before_action :set_post, only: %i[ index create ]

  def index
    @comments = @post.comments
  end

  def create
    @comment = @post.new(comment_params)
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
