require "test_helper"

class UsersLoginTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:taro)
  end
  
  test "login with invalid information" do
    get login_path
    post login_path, params: { session: { email: '', password: ''}}
    assert_template 'sessions/new'
    assert_not is_logged_in?
    assert_not flash.empty?
    get root_path
    assert flash.empty?
  end

  test "login with valid information followed by logout" do
    get login_path
    post login_path, params: { session: { email: @user.email,
                                          password: 'password' }}
    assert_redirected_to user_path(@user)
  assert is_logged_in?
    follow_redirect!
    assert_template 'users/show'
    assert_select 'a[href=?]', login_path, count: 0
    assert_select 'a[href=?]', logout_path
    assert_select 'a[href=?]', user_path(@user)
    get root_path
    assert_select 'a[href=?]', signup_path, count: 0

    delete logout_path
    assert_not is_logged_in?
    assert_redirected_to root_path
    follow_redirect!
    assert_select 'a[href=?]', login_path
    assert_select 'a[href=?]', logout_path, count: 0
    assert_select 'a[href=?]', user_path(@user), count: 0
    assert_select 'a[href=?]', signup_path

    # 二度目のログアウト
    delete logout_path
    assert_not is_logged_in?
    assert_redirected_to root_url

  end

  test "login with valid email/invalid password" do
    get login_path
    post login_path, params: { session: { email: @user.email,
                                        password: 'invalid' }}
    assert_template 'sessions/new'
    assert_not is_logged_in?
    assert_not flash.empty?
    get root_path
    assert flash.empty?
  end

  test "login with remembering" do
    log_in_as(@user, remember_me: '1')
    assert_not_empty cookies[:remember_token]
    assert_equal cookies[:remember_token], assigns(:user).remember_token
  end

  test "login without remembering" do
    log_in_as(@user,remember_me: '1')
    delete logout_path
    assert_empty cookies[:remember_token]
    log_in_as(@user, remember_me: '0')
    assert_empty cookies[:remember_token]
  end
end
