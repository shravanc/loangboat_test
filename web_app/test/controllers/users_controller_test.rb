require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  test 'Should give 200 response' do
    get '/users'
    assert_response :success
  end

  test 'content type validation' do
    get '/users'
    assert_equal response.content_type, 'application/json'
  end
end
