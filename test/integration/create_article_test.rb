require "test_helper"

class CreateCategoryTest < ActionDispatch::IntegrationTest
  setup do
    @admin_user = User.create(username: "johndoe",
    email: "johndoe@example.com", password: "password",
    admin: true)
    sign_in_as(@admin_user)
  end

  test "get new article form and create article" do
    get "/articles/new"
    assert_response :success
    assert_difference 'Article.count', 1 do
      post articles_path, params: { article: {title: "Some random title",
        description: "Some random description", category_ids: []}}
      assert_response :redirect
    end

    follow_redirect!
    assert_response :success
    assert_match "Some random title ", response.body
  end

  test "get new article form and reject invalid submission" do
    get "/articles/new"
    assert_response :success
    assert_difference 'Article.count', 0 do
        post articles_path, params: { article: {title: "s",
            description: "Some random description", category_ids: []}}
        assert_match "errors prevented", response.body
    end
  end
end
