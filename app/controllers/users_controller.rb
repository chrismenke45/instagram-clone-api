class UsersController < ApplicationController
  before_action :set_user, only: [:show, :update, :destroy]

  def create
    @user = User.new(user_params)
    if @user.save
      render :json => user_object_jwt(@user)
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  def show
    render :json => @user
  end

  def update
  end

  def destory
    if @user.destory
      render :json => { message: "User #{@user.id} destroyed" }, status: 200
    else
      render :json => { error: "User #{@user.id} could not be destroyed" }, status: 200
    end
  end

  private

  def user_params
    params.require(:user).permit(:username, :name, :bio, :profile_picture, :password)
  end

  def set_user
    @user = User.select(:username, :id, :name, :bio, :profile_picture).where("id = ?", params[:id])
  end
end
