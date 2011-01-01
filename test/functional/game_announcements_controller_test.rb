require 'test_helper'

class GameAnnouncementsControllerTest < ActionController::TestCase
  setup do
    @game_announcement = game_announcements(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:game_announcements)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create game_announcement" do
    assert_difference('GameAnnouncement.count') do
      post :create, :game_announcement => @game_announcement.attributes
    end

    assert_redirected_to game_announcement_path(assigns(:game_announcement))
  end

  test "should show game_announcement" do
    get :show, :id => @game_announcement.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @game_announcement.to_param
    assert_response :success
  end

  test "should update game_announcement" do
    put :update, :id => @game_announcement.to_param, :game_announcement => @game_announcement.attributes
    assert_redirected_to game_announcement_path(assigns(:game_announcement))
  end

  test "should destroy game_announcement" do
    assert_difference('GameAnnouncement.count', -1) do
      delete :destroy, :id => @game_announcement.to_param
    end

    assert_redirected_to game_announcements_path
  end
end
