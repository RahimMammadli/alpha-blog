require "test_helper"

class UserSignup < ActionDispatch::IntegrationTest

  test "get new user form and create user" do
    get "/signup"
    assert_response :success
    assert_difference 'User.count', 1 do
        post "/users", params: {user: {username: "Rand", email: "Rand@damn.com", password: "pass"}}
        assert_response :redirect
    end

    follow_redirect!
    assert_response :success
    assert_match "you have successfully signed up", response.body
  end

  test "get new user form and reject invalid user submission" do
    get "/signup"
    assert_response :success
    assert_no_difference 'User.count' do
        post "/users", params: {user: {username: "Rand", email: "Rand@com", password: "pass"}}
        assert_response :success
    end

    assert_match "Sign up for", response.body
  end
end
