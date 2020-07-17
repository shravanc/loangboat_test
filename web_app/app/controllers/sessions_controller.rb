class SessionsController < ApplicationController
  before_action :validate_username, only: :create

  # 
  def index
    redirect_to action: 'new'
  end

  # Form for User Login
  def new; end

  # Create Session for User with the Form data
  def create
    status, data = @current_user.validate_credentials(credentials)
    if status
      session = Session.create!(session_attributes)
      if session.valid?
        @session_id = session.session_id
        render :create, status: :created
      else
        flash[:invalid_credentials] = 'Please try again!'
        redirect_to action: 'new'
      end
    else
      flash[:invalid_credentials] = data[:message]
      redirect_to action: 'new'
    end
  end

  # Log out API request, to delete session for a User
  def destroy
    session = Session.find_by_session_id(params[:id])
    session.destroy
    flash[:notice] = 'You are successfully Logged out'
    redirect_to action: 'new'
  end

  private

  def credentials
    params.require(:session).permit(%i[username password])
  end

  def session_attributes
    { session_id: SecureRandom.hex(10), user_id: @current_user.id }
  end
end
