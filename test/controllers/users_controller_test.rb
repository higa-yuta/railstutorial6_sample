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

  

  # TODO: only active user in show action test
end