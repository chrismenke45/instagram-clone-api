class AuthenticationsController < ApplicationController
  include JwtToken

  def login
    @user = User.find_by(username: auth_params[:username])
    if @user.authenticate(auth_params[:password])
      user_object = {
        username: @user[:username],
        user_id: @user[:id],
      }
      jwt = jwt_encode(user_object)
      render :json => { t: jwt }
    else
      render json: { error: "Username or password incorrect" }, status: :unauthorized
    end
  end

  def auth_params
    params.require(:auth).permit(:username, :password)
  end
end
