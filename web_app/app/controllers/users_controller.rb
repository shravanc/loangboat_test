class UsersController < ApplicationController
  def index
    render json: { "data": { "users": User.all.as_json } }
  end
end
