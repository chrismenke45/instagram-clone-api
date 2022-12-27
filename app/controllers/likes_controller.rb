class LikesController < ApplicationController
  def create
    @like = Like.new(post_id: params[:post_id])
    #@like.user_id = current_user.id

  end

  def destroy
    @like = Like.find(params[:id])
    @like.destory
  end
end
