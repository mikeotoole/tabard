require 'test_helper'

class TeamspeaksControllerTest < ActionController::TestCase
  setup do
    @teamspeak = teamspeaks(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:teamspeaks)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create teamspeak" do
    assert_difference('Teamspeak.count') do
      post :create, :teamspeak => @teamspeak.attributes
    end

    assert_redirected_to teamspeak_path(assigns(:teamspeak))
  end

  test "should show teamspeak" do
    get :show, :id => @teamspeak.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @teamspeak.to_param
    assert_response :success
  end

  test "should update teamspeak" do
    put :update, :id => @teamspeak.to_param, :teamspeak => @teamspeak.attributes
    assert_redirected_to teamspeak_path(assigns(:teamspeak))
  end

  test "should destroy teamspeak" do
    assert_difference('Teamspeak.count', -1) do
      delete :destroy, :id => @teamspeak.to_param
    end

    assert_redirected_to teamspeaks_path
  end
end
