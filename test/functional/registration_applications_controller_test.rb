require 'test_helper'

class RegistrationApplicationsControllerTest < ActionController::TestCase
  setup do
    @registration_application = registration_applications(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:registration_applications)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create registration_application" do
    assert_difference('RegistrationApplication.count') do
      post :create, :registration_application => @registration_application.attributes
    end

    assert_redirected_to registration_application_path(assigns(:registration_application))
  end

  test "should show registration_application" do
    get :show, :id => @registration_application.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @registration_application.to_param
    assert_response :success
  end

  test "should update registration_application" do
    put :update, :id => @registration_application.to_param, :registration_application => @registration_application.attributes
    assert_redirected_to registration_application_path(assigns(:registration_application))
  end

  test "should destroy registration_application" do
    assert_difference('RegistrationApplication.count', -1) do
      delete :destroy, :id => @registration_application.to_param
    end

    assert_redirected_to registration_applications_path
  end
end
