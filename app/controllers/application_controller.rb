class ApplicationController < ActionController::API
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
end
