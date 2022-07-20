require "test_helper"

class UsersSignupTest < ActionDispatch::IntegrationTest

  def setup
    ActionMailer::Base.deliveries.clear
  end
  
  test "invalid signup information" do
    get signup_path
    assert_no_difference 'User.count' do
      post users_path, params: { user: { name: "",
                                         email: "okinawa@sample.com",
                                         password: 'ok',
                                         password_confirmation: 'ok' }}
    end
    assert_template 'users/new'
    assert_select "div#error_explanation" do
      assert_select "ul" do
        assert_select "li", 2
      end
    end
  end

  test "valid signup information with account activation" do
    assert_difference 'User.count', 1 do
      post users_path, params: { user: { name: "okinawa taro",
                                         email: "okinawa@sample.com",
                                         password: "okinawa",
                                         password_confirmation: "okinawa" }}
    end
    assert_equal 1, ActionMailer::Base.deliveries.size
    user = assigns(:user)
    assert_not user.activated?
    # activated: falseの場合にログイン
    log_in_as(user)
    assert_not is_logged_in?
    # 不正な有効かトークンの場合
    get edit_account_activation_path("invalid token", email: user.email)
    assert_not is_logged_in?
    # token is true but email-address is false
    get edit_account_activation_path(user.activation_token, email: 'wrong')
    assert_not is_logged_in?
    # correct information
    get edit_account_activation_path(user.activation_token, email: user.email)
    assert user.reload.activated?
    follow_redirect!
    assert_template 'users/show'
    assert is_logged_in?
  end
  
end
