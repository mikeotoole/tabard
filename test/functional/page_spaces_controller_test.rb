require 'test_helper'

class PageSpacesControllerTest < ActionController::TestCase
  setup do
    @page_space = page_spaces(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:page_spaces)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create page_space" do
    assert_difference('PageSpace.count') do
      post :create, :page_space => @page_space.attributes
    end

    assert_redirected_to page_space_path(assigns(:page_space))
  end

  test "should show page_space" do
    get :show, :id => @page_space.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @page_space.to_param
    assert_response :success
  end

  test "should update page_space" do
    put :update, :id => @page_space.to_param, :page_space => @page_space.attributes
    assert_redirected_to page_space_path(assigns(:page_space))
  end

  test "should destroy page_space" do
    assert_difference('PageSpace.count', -1) do
      delete :destroy, :id => @page_space.to_param
    end

    assert_redirected_to page_spaces_path
  end
end
