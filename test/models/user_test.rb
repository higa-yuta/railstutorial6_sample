require "test_helper"

class UserTest < ActiveSupport::TestCase
  
  def setup
    @user = User.new(name: "okinawa taro", email: 'okinawa@sample.com')
  end

  test "should be valid" do
    assert @user.valid?
  end

# NAME
  test "name should be present" do
    @user.name = ""
    assert_not @user.valid?
  end

  test "name should not be too long(50 character)" do
    @user.name = 'a' * 51
    assert_not @user.valid?
  end

# EMAIL
  test "email should be present" do
    @user.email = ""
    assert_not @user.valid?
  end

  test "email should not be too long(255 character)" do
    @user.email = "a" * 245 + "@sample.com"
    assert_not @user.valid?
  end

  test "email validation should accept valid addresses" do
    valid_addresses = %w[user@example.com USER@foo.COM A_US-ER@foo.bar.org  first.last@foo.jp alice+bob@bax.cn]
    valid_addresses.each do |valid_address|
      @user.email = valid_address
      assert @user.valid?, "#{valid_address.inspect} should be valid"
    end
  end

  test "email validation should reject invalid addresses" do
    invalid_addresses = %w[user@example,com user_at_foo.org A_US-ER.org  first.last@foo foo@bar_baz.com foo@bar+bax.com]
    invalid_addresses.each do |invalid_address|
      @user.email = invalid_address
      assert_not @user.valid?, "#{invalid_address.inspect} should be invalid"
    end
  end

  test "email addresses should be unique" do
    dup_user = @user.dup
    dup_user.email.upcase!
    @user.save
    assert_not dup_user.valid?
  end
end
