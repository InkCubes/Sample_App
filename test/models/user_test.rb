require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def setup
    @user = User.new(name: "Example User", email: "user@example.com",
                      password: "password",
                      password_confirmation: "password")
  end

  test "should be valid" do
    assert @user.valid?
  end

  test "name should be present" do
    @user.name = "        "
    assert_not @user.valid?
  end

  test "name not too long" do
    @user.name = "a" * 51
    assert_not @user.valid?
  end

  test "email not too long" do
    @user.email = "a" * 255 + "@example.com"
    assert_not @user.valid?
  end

  test "reject invalid email" do
    invalid_addresses = %w[user@example,com user_at_foo.org user.name@example. foo@bar_baz.com foo@bar+baz.com]
    invalid_addresses.each do |address|
      @user.email = address
      assert_not @user.valid?, "#{address.inspect} should be invalid"
    end
  end

  test "email should be unique" do
    duplicate_user = @user.dup
    duplicate_user.email = @user.email.upcase
    @user.save
    assert_not duplicate_user.valid?
  end

  test "email is downcase" do
    a = "AN@EXAMPLE.COM"
    @user.email = a
    @user.save
    assert @user.email == a.downcase, "#{@user.email.inspect} should be downcase"

  end

  test "password long enough" do
    @user.password = @user.password_confirmation = "12345"
    assert_not @user.valid?
  end

  test "password not blank" do
    @user.password = @user.password_confirmation = " " * 6
    assert_not @user.valid?
  end
end
