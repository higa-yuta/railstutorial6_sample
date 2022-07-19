require "test_helper"

class UsersIndexTest < ActionDispatch::IntegrationTest

  def setup
    @admin = users(:taro)
    @non_admin = users(:jiro)
  end

  test "should get index with logged in user" do
    get users_path
    assert_redirected_to login_path
    log_in_as(@admin)
    get users_path
    assert_template 'users/index'
  end

  test "index as admin including including pagination and delete links" do
    log_in_as(@admin)
    get users_path
    assert_template 'users/index'
    assert_select 'div.pagination'
    assert_select 'ul.users li', 10
    User.paginate(page: 1, per_page: 10).order('name ASC').each do |user|
      assert_select 'a[href=?]', user_path(user), text: user.name
      unless user == @admin
        assert_select 'a[href=?]', user_path(user), text: 'delete'
      end
    end
    assert_difference 'User.count', -1 do
      delete user_path(@non_admin)
    end
  end

  test "index as non-admin" do
    log_in_as(@non_admin)
    get users_path
    assert_select 'a', text: 'delete', count: 0
  end

  test "do not show if user is inactive" do
    @non_admin.update_attribute(:activated, false)
    assert_equal false, @non_admin.activated
    log_in_as(@admin)
    get users_path
    assert_not assigns(:users).include?(@non_admin)
  end

end
