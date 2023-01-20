class UsersController < ApplicationController
  before_action :set_user, only: [:update, :destroy]
  before_action :authenticate_user, except: [:create]

  def create
    @user = User.new(user_params)
    if @user.save
      render :json => user_object_jwt(@user)
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  def show
    p "*************************"
    p params
    @user = User.left_outer_joins(:posts)
      .select("Users.username, Users.name, Users.id, Count(DISTINCT Posts.id) as post_count, Users.bio, Users.profile_picture")
    #  .select("Users.username, Users.name, Users.id, Users.bio, Users.profile_picture")
      .group("users.id")
      .where("Users.id = ?", params[:id])
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
