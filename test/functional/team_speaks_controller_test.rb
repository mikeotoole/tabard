require 'test_helper'

class TeamSpeaksControllerTest < ActionController::TestCase
  setup do
    @team_speak = team_speaks(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:team_speaks)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create team_speak" do
    assert_difference('TeamSpeak.count') do
      post :create, :team_speak => @team_speak.attributes
    end

    assert_redirected_to team_speak_path(assigns(:team_speak))
  end

  test "should show team_speak" do
    get :show, :id => @team_speak.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @team_speak.to_param
    assert_response :success
  end

  test "should update team_speak" do
    put :update, :id => @team_speak.to_param, :team_speak => @team_speak.attributes
    assert_redirected_to team_speak_path(assigns(:team_speak))
  end

  test "should destroy team_speak" do
    assert_difference('TeamSpeak.count', -1) do
      delete :destroy, :id => @team_speak.to_param
    end

    assert_redirected_to team_speaks_path
  end
end
