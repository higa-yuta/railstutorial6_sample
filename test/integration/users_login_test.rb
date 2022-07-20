require "test_helper"

class UsersLoginTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:taro)
    @other_user = users(:jiro)
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

  test "should redirect edit when not logged in" do
    get edit_user_path(@user)
    assert_not flash.empty?
    assert_redirected_to login_path
  end

  test "should redirect edit when logged in as wrong user" do
    log_in_as(@other_user)
    get edit_user_path(@user)
    assert flash.empty?
    assert_redirected_to root_path
  end

  test "should redirect update when not logged in" do
    patch user_path(@user), params: { user: { name: @user.name,
                                              email: @user.email}}
    assert_not flash.empty?
    assert_redirected_to login_path
  end

  test "should redirect update when logged in as wrong user" do
    log_in_as(@other_user)
    patch user_path(@user), params: { user: { name: @user.name,
                                              email: @user.email }}
    assert flash.empty?
    assert_redirected_to root_path
  end

  test "should not allow the admin attribute to be edited via the web" do
    log_in_as(@other_user)
    assert_not @other_user.admin?
    patch user_path(@other_user), params: { user: { password: 'password',
                                                    password: 'password',
                                                    admin: true }}
    assert_not @other_user.reload.admin?
  end

  test "if a non-logged-in user performs a destructive operation, redirect to login" do
    assert_no_difference 'User.count' do
      delete user_path(@user)
    end
    assert_redirected_to login_path
  end

  test "if a logged-in as a non-admin user performs a destructive operation, redirect to root" do
    log_in_as(@other_user)
    assert_no_difference 'User.count' do
      delete user_path(@user)
    end
    assert_redirected_to root_path
  end

  test "should redirect show when not logged in" do
    get user_path(@user)
    assert_redirected_to login_path
  end

  test "should redirect root when show inactive user page" do
    log_in_as(@user)
    @other_user.update_attribute(:activated, false)
    get user_path(@other_user)
    assert_redirected_to root_path
  end
end
