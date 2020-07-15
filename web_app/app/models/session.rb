class Session < ApplicationRecord

belongs_to :user


def create params
  user = params[:user]
  status, data = user.validate_credentials(session_params(params))
  unless status
    return [false, data]
  end
  user.sessions.destroy_all
  user.sessions << Session.create(session_id: SecureRandom.hex(10))
  data[:session_id] = user.sessions.last.session_id
  [true, data]
end

private

def session_params params
  params.require(:session).permit([:username, :password])
end



end
