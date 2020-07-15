class SessionsController < ApplicationController
before_action :validate_username, only: :create


def create
  session = Session.new
  status, data = session.create(params)
  if status
    render :show
    #render json: data, status: :created
  else
    render json: data, status: :unprocessable_entity
  end
end

def show
end

def destroy
  session = Session.find_by_session_id(params[:id])
  session.destroy
  render json: {message: 'Session destroyed successfully'}, status: :ok
end


end
