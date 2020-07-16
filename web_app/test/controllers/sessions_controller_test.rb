require 'test_helper'

class SessionsControllerTest < ActionDispatch::IntegrationTest
  test 'test Login' do
    user = user = User.create(username: 'sample', email: 'sample@gmail.com', password: 'password', verified: true)
    post '/sessions', params: { 'session': { 'username': user.username, 'password': 'password' } }
    assert_response 201
  end

  test 'Sign out' do
    session = sessions(:user_1_session)
    delete "/sessions/#{session.session_id}"
    assert_response :found
  end

  test 'Invalid Creatials' do
    user = user = User.create(username: 'sample', email: 'sample@gmail.com', password: 'password', verified: true)
    post '/sessions', params: { 'session': { 'username': user.username, 'password': 'invalid_password' } }
    assert_response :found
  end

  test 'Invalid Creatials for more than 3 times' do
    user = user = User.create(username: 'sample', email: 'sample@gmail.com', password: 'password', verified: true)
    post '/sessions', params: { 'session': { 'username': user.username, 'password': 'invalid_password' } }
    post '/sessions', params: { 'session': { 'username': user.username, 'password': 'invalid_password' } }
    post '/sessions', params: { 'session': { 'username': user.username, 'password': 'invalid_password' } }
    post '/sessions', params: { 'session': { 'username': user.username, 'password': 'invalid_password' } }
    assert_response :found
    assert_equal flash[:invalid_credentials], 'Maximum Attempt Reached!'
  end

  test 'Resetting Failed count after successful login' do
    user = user = User.create(username: 'sample', email: 'sample@gmail.com', password: 'password', verified: true)
    post '/sessions', params: { 'session': { 'username': user.username, 'password': 'invalid_password' } }
    post '/sessions', params: { 'session': { 'username': user.username, 'password': 'invalid_password' } }
    assert_equal User.find_by_username('sample').failure_count, 2
    post '/sessions', params: { 'session': { 'username': user.username, 'password': 'password' } }
    assert_equal User.find_by_username('sample').failure_count, 0
    assert_response :created
  end
end
