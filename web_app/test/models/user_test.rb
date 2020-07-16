require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test 'Username to be a mandatory Field' do
    user = User.create(email: 'sample@gmail.com', password: 'welcome')
    assert_not user.valid?
  end

  test 'Email to be mandatory mandatory Field' do
    user = User.create(username: 'sample', password: 'welcome')
    assert_not user.valid?
  end

  test 'Unique username test' do
    user_1 = User.create(username: 'sample', email: 'sample@gmail.com', password: 'welcome')
    user_2 = User.create(username: 'sample', email: 'sample@gmail.com', password: 'welcome')
    assert user_1.valid?
    assert_not user_2.valid?
  end

  test 'Password encryption' do
    user = User.create(username: 'sample', email: 'sample@gmail.com', password: 'welcome')
    assert user.password != 'welcome'
  end

  test 'Password Length test' do
    user = User.create(username: 'sample', password: 'abc')
    assert_not user.valid?
  end

  test 'Valid User parameters' do
    user = users(:user_1)
    assert user.valid?
  end

  test 'Session Association' do
    user = users(:user_1)
    assert_equal 1, user.sessions.size
  end

  test 'Destroy User should delete associated sessions' do
    sessions = sessions(:user_1_session)
    user = sessions.user
    user.destroy
    assert_equal 0, Session.count
  end
end
