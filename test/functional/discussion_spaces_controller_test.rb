require 'test_helper'

class DiscussionSpacesControllerTest < ActionController::TestCase
  setup do
    @discussion_space = discussion_spaces(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:discussion_spaces)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create discussion_space" do
    assert_difference('DiscussionSpace.count') do
      post :create, :discussion_space => @discussion_space.attributes
    end

    assert_redirected_to discussion_space_path(assigns(:discussion_space))
  end

  test "should show discussion_space" do
    get :show, :id => @discussion_space.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @discussion_space.to_param
    assert_response :success
  end

  test "should update discussion_space" do
    put :update, :id => @discussion_space.to_param, :discussion_space => @discussion_space.attributes
    assert_redirected_to discussion_space_path(assigns(:discussion_space))
  end

  test "should destroy discussion_space" do
    assert_difference('DiscussionSpace.count', -1) do
      delete :destroy, :id => @discussion_space.to_param
    end

    assert_redirected_to discussion_spaces_path
  end
end
