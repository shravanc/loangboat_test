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
    render json: {message: 'Account not verified'}, status: :unauthorized
    return
  elsif user.failure_count >= 3
    flash[:invalid_credentials] = 'Maximum Attempt Reached!'
    redirect_to :action => "new"#, status: :locked

    #render json: {message: 'Maximum attempt reached'}, status: :unauthorized
    return
  end
  @current_user = user
end

  def render_error(resource, status)
    render json: resource, status: status, adapter: :json_api, serializer: ActiveModel::Serializer::ErrorSerializer
  end

end
