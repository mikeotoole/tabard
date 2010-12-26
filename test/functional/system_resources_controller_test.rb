require 'test_helper'

class SystemResourcesControllerTest < ActionController::TestCase
  setup do
    @system_resource = system_resources(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:system_resources)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create system_resource" do
    assert_difference('SystemResource.count') do
      post :create, :system_resource => @system_resource.attributes
    end

    assert_redirected_to system_resource_path(assigns(:system_resource))
  end

  test "should show system_resource" do
    get :show, :id => @system_resource.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @system_resource.to_param
    assert_response :success
  end

  test "should update system_resource" do
    put :update, :id => @system_resource.to_param, :system_resource => @system_resource.attributes
    assert_redirected_to system_resource_path(assigns(:system_resource))
  end

  test "should destroy system_resource" do
    assert_difference('SystemResource.count', -1) do
      delete :destroy, :id => @system_resource.to_param
    end

    assert_redirected_to system_resources_path
  end
end
