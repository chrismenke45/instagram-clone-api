class AuthenticationsController < ApplicationController
  def login
    @user = User.find_by(username: auth_params[:username])
    if @user.authenticate(auth_params[:password])
      render :json => @user
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  def auth_params
    params.require(:auth).permit(:username, :password)
  end
end
