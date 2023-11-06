require "test_helper"

class Users::PostsControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get users_posts_new_url
    assert_response :success
  end

  test "should get index" do
    get users_posts_index_url
    assert_response :success
  end

  test "should get show" do
    get users_posts_show_url
    assert_response :success
  end

  test "should get edit" do
    get users_posts_edit_url
    assert_response :success
  end
end
