class UsersController < ApplicationController

def index
  render json: {"data": {"users": User.all.as_json } }
end

def create
  user = User.new
  status, data = user.create(params)
  if status
    render json: data, status: :created
  else
    render json: data, status: :unprocessable_entity
  end
end


end
