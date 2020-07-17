class ApplicationController < ActionController::Base
  skip_before_action :verify_authenticity_token

  def validate_username
    username = params[:action] == 'forgot_password' ? params[:user][:username] : params[:session][:username]
    logger.warn username
    user = User.find_by_username(username)
    if user.nil?
      flash[:invalid_credentials] = 'Invalid username'
      redirect_to action: 'new'
    elsif !user.verified
      flash[:invalid_credentials] = 'Account not verified'
      redirect_to action: 'new'
    elsif user.failure_count >= 3
      flash[:invalid_credentials] = 'Maximum Attempt Reached!'
      redirect_to action: 'new'
    end
    @current_user = user
  end
end
