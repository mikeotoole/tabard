require 'test_helper'

class SiteFormsControllerTest < ActionController::TestCase
  setup do
    @site_form = site_forms(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:site_forms)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create site_form" do
    assert_difference('SiteForm.count') do
      post :create, :site_form => @site_form.attributes
    end

    assert_redirected_to site_form_path(assigns(:site_form))
  end

  test "should show site_form" do
    get :show, :id => @site_form.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @site_form.to_param
    assert_response :success
  end

  test "should update site_form" do
    put :update, :id => @site_form.to_param, :site_form => @site_form.attributes
    assert_redirected_to site_form_path(assigns(:site_form))
  end

  test "should destroy site_form" do
    assert_difference('SiteForm.count', -1) do
      delete :destroy, :id => @site_form.to_param
    end

    assert_redirected_to site_forms_path
  end
end
