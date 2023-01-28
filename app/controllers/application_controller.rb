class ApplicationController < ActionController::API
  include JwtToken
  before_action :cors_set_access_control_headers

  private

  #set headers
  def cors_set_access_control_headers
    #headers["Access-Control-Allow-Origin"] = "*"
    headers["Access-Control-Allow-Origin"] = ENV["CLIENT_URL"]
    headers["Access-Control-Allow-Methods"] = "POST, PUT, DELETE, GET, OPTIONS"
    headers["Access-Control-Request-Method"] = "*"
    headers["Access-Control-Allow-Headers"] = "Origin, X-Requested-With, Content-Type, Accept, Authorization"
  end

  def find_current_user_followings #this must be run AFTER authenticate user
    @current_user_followings = Follow.where("follower_id = ?", @current_user.id).pluck(:followee_id)
    @current_user_followings = [0] if @current_user_followings.empty?
  end

  def authenticate_user
    header = request.headers["Authorization"]
    header = header.split(" ").last if header
    begin
      @decoded = jwt_decode(header)
      @current_user = User.find(@decoded[:user_id])
    rescue ActiveRecord::RecordNotFound => e
      render json: { errors: e.message }, status: :unauthorized
    rescue JWT::DecodeError => e
      render json: { errors: e.message }, status: :unauthorized
    end
  end

  def user_object_jwt(user)
    user_object = {
      username: user[:username],
      user_id: user[:id],
      profile_picture: user[:profile_picture],
    }
    { t: jwt = jwt_encode(user_object) }
  end
end
