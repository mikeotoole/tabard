require 'test_helper'

class SiteAnnouncementsControllerTest < ActionController::TestCase
  setup do
    @site_announcement = site_announcements(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:site_announcements)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create site_announcement" do
    assert_difference('SiteAnnouncement.count') do
      post :create, :site_announcement => @site_announcement.attributes
    end

    assert_redirected_to site_announcement_path(assigns(:site_announcement))
  end

  test "should show site_announcement" do
    get :show, :id => @site_announcement.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @site_announcement.to_param
    assert_response :success
  end

  test "should update site_announcement" do
    put :update, :id => @site_announcement.to_param, :site_announcement => @site_announcement.attributes
    assert_redirected_to site_announcement_path(assigns(:site_announcement))
  end

  test "should destroy site_announcement" do
    assert_difference('SiteAnnouncement.count', -1) do
      delete :destroy, :id => @site_announcement.to_param
    end

    assert_redirected_to site_announcements_path
  end
end
