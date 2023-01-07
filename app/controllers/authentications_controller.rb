class AuthenticationsController < ApplicationController
  include JwtToken

  def login
    @user = User.find_by(username: auth_params[:username])
    if @user.authenticate(auth_params[:password])
      render :json => user_object_jwt(@user)
    else
      render json: { error: "Username or password incorrect" }, status: :unauthorized
    end
  end

  def auth_params
    params.require(:auth).permit(:username, :password)
  end
end
