require "test_helper"

class UsersSignupTest < ActionDispatch::IntegrationTest
  
  test "invalid signup information" do
    get signup_path
    assert_no_difference 'User.count' do
      post users_path, params: { user: { name: "",
                                         email: "okinawa@sample.com",
                                         password: 'ok',
                                         password_confirmation: 'ok' }}
    end
    follow_redirect!
    assert_template 'users/new'
    assert_select "div#error_explanation" do
      assert_select "ul" do
        assert_select "li", 2
      end
    end
  end

  test "valid signup information" do
    assert_difference 'User.count', 1 do
      post users_path, params: { user: { name: "okinawa taro",
                                         email: "okinawa@sample.com",
                                         password: "okinawa",
                                         password_confirmation: "okinawa" }}
    end
    follow_redirect!
    assert_template "users/show"
    assert_select "h1", "okinawa taro"
    assert_select "div.alert-success", "登録が完了しました"
    assert is_logged_in?
  end
  
end
