class SessionsController < ApplicationController
before_action :validate_username, only: :create

# Form for User Login
def new
end

# Create Session for User with the Form data
def create
  status, data = @current_user.validate_credentials(credentials)
  if status
    session = Session.new(session_attributes)
    if session.save
      @session_id = session.session_id
      render :create, status: :created
    else
      render_error(session, :unprocessable_entity)
    end
  else
    flash[:invalid_credentials] = data[:message]
    redirect_to :action => "new"#, status: :unprocessable_entity
  end
end

# 
def destroy
  session = Session.find_by_session_id(params[:id])
  session.destroy
  flash[:notice] = "You are successfully Logged out"
  redirect_to :action => "new"#, status: :ok
end


private 

def credentials
  params.require(:session).permit([:username, :password])
end

def session_attributes
  {session_id: SecureRandom.hex(10), user_id: @current_user.id}
end


end
