class UsersController < ApplicationController
  #include JwtToken

  def create
    @user = User.new(user_params)
    if @user.save
      render :json => user_object_jwt(@user)
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  def show
  end

  def update
  end

  def destory
  end

  private

  def user_params
    params.require(:user).permit(:username, :name, :bio, :profile_picture, :password)
  end

  # def password
  #   @password ||= Password.new(password_hash)
  # end

  # def password=(new_password)
  #   @password = Password.create(new_password)
  #   self.password_hash = @password
  # end
end
