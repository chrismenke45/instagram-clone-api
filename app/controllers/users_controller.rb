class UsersController < ApplicationController
  before_action :set_user, only: [:update, :destroy]
  before_action :authenticate_user, except: [:create, :index]

  def index
    if params[:usernameOnly]
      @users = User.select("username").where("LOWER(username) LIKE :name_lookup", { name_lookup: params[:search].downcase })
    else
      @users = User.select("username, id as user_id, name, profile_picture").where("LOWER(username) LIKE :name_lookup OR LOWER(name) LIKE :name_lookup", { name_lookup: (params[:search].downcase + "%") })
    end
    render :json => @users
  end

  def create
    @user = User.new(user_params)
    if @user.save
      render :json => user_object_jwt(@user)
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  def show
    @user = User.left_outer_joins(:posts)
      .joins("LEFT OUTER JOIN follows AS followees ON followees.follower_id = users.id")
      .joins("LEFT OUTER JOIN follows AS followers ON followers.followee_id = users.id")
      .select("Users.username, Users.name, Users.id, Count(DISTINCT Posts.id) as post_count, Users.bio, Users.profile_picture, COUNT(DISTINCT followees.followee_id) AS followee_count, COUNT(DISTINCT followers.follower_id) AS follower_count, CAST(CAST(SUM(DISTINCT CASE WHEN followers.follower_id = #{@current_user.id} THEN 1 ELSE 0 END) AS INT) AS BOOLEAN) as current_user_follows")
      .group("users.id")
      .where("Users.id = ?", params[:id])
    render :json => @user
  end

  def update
    if @user.username === "guest"
      render :json => { error: "Guest user can not be updated" }, status: :unauthorized
    elsif @user.update(user_params)
      render :json => { message: "User #{@user.id} updated" }, status: 200
    else
      render :json => { error: "User #{@user.id} could not be updated" }, status: :unprocessable_entity
    end
  end

  def destroy
    if @user.username === "guest"
      render :json => { error: "Guest user can not be deleted" }, status: :unauthorized
    elsif @user.destroy
      render :json => { message: "User #{@user.id} destroyed" }, status: 200
    else
      render :json => { error: "User #{@user.id} could not be destroyed" }, status: :conflict
    end
  end

  private

  def user_params
    params.require(:user).permit(:username, :name, :bio, :profile_picture, :password)
  end

  def set_user
    @user = User.find(params[:id])
  end
end
