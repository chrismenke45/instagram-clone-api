class PostsController < ApplicationController
  def index
  end

  def create
  end

  def show
  end

  def destroy
  end

  def record_params
    params.require(:post).permit(:picture_url, :caption)
  end
end
