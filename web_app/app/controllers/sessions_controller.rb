class SessionsController < ApplicationController
before_action :validate_username, only: :create

def new
end


def index
  @user = User.last
end

def create
  session = Session.new
  status, data = session.create(params)
  if status
    @user = params[:user]
    @session_id = data[:session_id]
    render 
    return
  else
    redirect_to :action => "new"
  end
end

def show
end

def destroy
  session = Session.find_by_session_id(params[:id])
  session.destroy
  redirect_to :action => "new"
end


end
