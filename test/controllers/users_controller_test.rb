require "test_helper"

class UsersControllerTest < ActionDispatch::IntegrationTest

  def setup 
    @user = users(:taro)
    @other_user = users(:jiro)
  end

  test "should get index" do
    log_in_as(@user)
    get users_path
    assert_template 'users/index'
    assert_select "title", "All users | Ruby on Rails Tutorial Sample App"
  end

  test "should redirect index when not logged in" do
    get users_path
    assert_redirected_to login_path
  end

  test "should get new" do
    get signup_path
    assert_template 'users/new'
    assert_select "title", "Sign up | Ruby on Rails Tutorial Sample App"
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

  # TODO: 他のアクションのテスト[:show]
end