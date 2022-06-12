require 'test_helper'

class SessionsHelperTest < ActionView::TestCase

  def setup
    @user = users(:taro)
    remember(@user)
  end

  test "current_user returns right user when session is nil" do
    assert_nil session[:user_id]
    assert_equal @user, current_user
    assert is_logged_in?
  end

  test "current_user returns nil when session is nil and remember digest is wrong" do
    assert_nil session[:user_id]
    @user.update_attribute(:remember_digest, User.digest(User.new_token))
    assert_nil current_user
  end
end