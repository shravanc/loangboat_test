require 'test_helper'

class SessionsControllerTest < ActionDispatch::IntegrationTest

test "Should delete session" do
  user = user = User.create(username: 'sample', email: 'sample@gmail.com', password: 'password', verified: true)
  post '/sessions', params: {'session': {'username': user.username, 'password': 'password'}}
  assert_response 201
end

end
