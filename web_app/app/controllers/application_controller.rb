class ApplicationController < ActionController::Base
   skip_before_action :verify_authenticity_token



def validate_username
  username = params[:action] == 'forgot_password' ? params[:user][:username] : params[:session][:username]
  logger.warn username
  user = User.find_by_username(username)
  if user.nil?
    render json: {message: 'Invalid username'}, status: :unauthorized
    return
  elsif !user.verified
    render json: {message: 'Account not verified'}
    return
  elsif user.failure_count > 3
    render json: {message: 'Maximum attempt reached'}, status: :unauthorized
    return
  end
  params[:user] = user
end


end
