require 'test_helper'

class SessionsControllerTest < ActionDispatch::IntegrationTest

test "test Login"do
  user = user = User.create(username: 'sample', email: 'sample@gmail.com', password: 'password', verified: true)
  post '/sessions', params: {'session': {'username': user.username, 'password': 'password'}}
  assert_response 200
end

test "Sign out" do
  session = sessions(:user_1_session)
  delete "/sessions/#{session.session_id}"
  assert_response 302
end

end
