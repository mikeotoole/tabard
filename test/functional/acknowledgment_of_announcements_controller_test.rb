require 'test_helper'

class AcknowledgmentOfAnnouncementsControllerTest < ActionController::TestCase
  setup do
    @acknowledgment_of_announcement = acknowledgment_of_announcements(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:acknowledgment_of_announcements)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create acknowledgment_of_announcement" do
    assert_difference('AcknowledgmentOfAnnouncement.count') do
      post :create, :acknowledgment_of_announcement => @acknowledgment_of_announcement.attributes
    end

    assert_redirected_to acknowledgment_of_announcement_path(assigns(:acknowledgment_of_announcement))
  end

  test "should show acknowledgment_of_announcement" do
    get :show, :id => @acknowledgment_of_announcement.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @acknowledgment_of_announcement.to_param
    assert_response :success
  end

  test "should update acknowledgment_of_announcement" do
    put :update, :id => @acknowledgment_of_announcement.to_param, :acknowledgment_of_announcement => @acknowledgment_of_announcement.attributes
    assert_redirected_to acknowledgment_of_announcement_path(assigns(:acknowledgment_of_announcement))
  end

  test "should destroy acknowledgment_of_announcement" do
    assert_difference('AcknowledgmentOfAnnouncement.count', -1) do
      delete :destroy, :id => @acknowledgment_of_announcement.to_param
    end

    assert_redirected_to acknowledgment_of_announcements_path
  end
end
