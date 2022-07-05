require "test_helper"

class UsersEditTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:taro)
  end

  test "unsuccessful edit" do
    log_in_as(@user)
    get edit_user_path(@user)
    assert_template 'users/edit'
    patch user_path(@user), params: { user: { name: '',
                                              email: 'foo@invalid',
                                              password: 'foo',
                                              password_confirmation: 'bar'}}
    assert_template 'users/edit'
    assert_select 'div#error_explanation' do
      assert_select 'ul' do
        assert_select 'li', 4
      end
    end
  end

  test "successful edit" do
    log_in_as(@user)
    get edit_user_path(@user)
    assert_template 'users/edit'
    patch user_path(@user), params: { user: { name: 'okinawa jiro',
                                              email: @user.email,
                                              password: '',
                                              password_confirmation: ''}}
    assert_redirected_to user_path(@user)
    assert_not flash.empty?
    follow_redirect!
    @user.reload
    assert_equal 'okinawa jiro', @user.name
  end

  test "successful edit with friendly forwarding" do
    get edit_user_path(@user)
    assert_redirected_to login_path
    log_in_as(@user)
    assert_redirected_to edit_user_path(@user)
    name = 'okinawa saburo'
    patch user_path(@user), params: { user: { name: name,
                                              email: @user.email}}
    assert_not flash.empty?
    assert_redirected_to user_path(@user)
    @user.reload
    assert_equal name, @user.name
  end

  test " Forwarding only the first time with friendly forwarding" do
    get edit_user_path(@user)
    assert_redirected_to login_path
    log_in_as(@user)
    assert_redirected_to edit_user_path(@user)
    assert_nil session[:forwarding_url]
  end
end
