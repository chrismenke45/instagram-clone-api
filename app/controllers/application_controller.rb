class ApplicationController < ActionController::API
  include JwtToken
  before_action :cors_set_access_control_headers

  private

  #set headers
  def cors_set_access_control_headers
    headers["Access-Control-Allow-Origin"] = "*"
    # headers["Access-Control-Allow-Origin"] = ENV["CLIENT_URL"]
    headers["Access-Control-Allow-Methods"] = "POST, PUT, DELETE, GET, OPTIONS"
    headers["Access-Control-Request-Method"] = "*"
    headers["Access-Control-Allow-Headers"] = "Origin, X-Requested-With, Content-Type, Accept, Authorization"
  end

  def authenticate_user
    header = request.headers["Authorization"]
    header = header.split(" ").last if header
    begin
      @decoded = JwtToken.decode(header)
      @current_user = User.find(@decoded[:user_id])
    rescue ActiveRecord::RecordNotFound => e
      render json: { errors: e.message }, status: :unauthorized
    rescue JWT::DecodeError => e
      render json: { errors: e.message }, status: :unauthorized
    end
  end

  def authorize
    @headers = request.headers
    if @headers["Authorization"].present?
      token = @headers["Authorization"].split(" ").last
      decoded_token = decode(token)
      @user = User.find_by(id: decoded_token[:user_id])
      render json: { error: "Not Authorized" }, status: 401 unless @user
    else
      render json: { error: "Not Authorized" }, status: 401
    end
  end

  def user_object_jwt(user)
    user_object = {
      username: user[:username],
      user_id: user[:id],
    }
    { t: jwt = jwt_encode(user_object) }
  end
end
