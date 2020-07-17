class ApplicationController < ActionController::Base
  skip_before_action :verify_authenticity_token

  def validate_username
    user = User.find_by_username(username['username'])
    if user.nil?
      flash[:invalid_credentials] = 'Invalid username'
      redirect_to action: 'new'
      return
    elsif !user.verified
      flash[:invalid_credentials] = 'Account not verified'
      redirect_to action: 'new'
      return
    elsif user.failure_count >= 3
      flash[:invalid_credentials] = 'Maximum Attempt Reached!'
      redirect_to action: 'new'
      return
    end
    @current_user = user
  end

  private
  def username
    params.require(:session).permit(%i[username])
  end
end
