require 'test_helper'

class CommunitiesControllerTest < ActionController::TestCase
  setup do
    @community = communities(:one)
  end

  ###
  # Index Tests
  ###
  test "should get index whilst authenticated as a user" do
    sign_in users(:billy)
    get :index
    assert_response :success
    assert_not_nil assigns(:communities)
  end

  test "should get index whilst not authenticated as a user" do
    get :index
    assert_response :success
    assert_not_nil assigns(:communities)
  end

  ###
  # New Tests
  ###
  test "should get new whilst authenticated as a user" do
    sign_in users(:billy)
    get :new
    assert_response :success
  end

  test "shouldn't get new whilst not authenticated as a user" do
    get :new
    assert_redirected_to new_user_session_path
  end

  ###
  # Create Tests
  ###
  test "should create community whilst authenticated as a user" do
    sign_in users(:billy)
    @community = Community.new(:name => "Test Guild", :slogan => "We rock", :label => "Guild")
    assert_difference('Community.count') do
      post :create, :community => @community.attributes
    end

    assert_redirected_to community_path(assigns(:community))
  end

  test "shouldn't create community whilst not authenticated as a user" do
    assert_no_difference('Community.count') do
      post :create, :community => @community.attributes
    end

    assert_redirected_to new_user_session_path
  end

  ###
  # Show Tests
  ###
  test "should redirect to community subdomain home whilst not authenticated as a user" do
    get :show, :id => @community.to_param
    assert_redirected_to subdomain_home_url(:subdomain => @community.subdomain)
  end

  test "show should redirect to subdomain whilst authenticated as a user" do
    sign_in users(:billy)
    get :show, :id => @community.to_param
    assert_redirected_to subdomain_home_url(:subdomain => @community.subdomain)
  end

  ###
  # Edit Tests
  ###
  test "should get edit whilst authenticated as a user" do
    sign_in users(:billy)
    get :edit, :id => @community.to_param
    assert_response :success
  end

  test "shouldn't get edit whilst not authenticated as a user" do
    get :edit, :id => @community.to_param
    assert_redirected_to new_user_session_path
  end

  ###
  # Update Tests
  ###
  test "should update community whilst authenticated as a user" do
    sign_in users(:billy)
    put :update, :id => @community.to_param, :community => @community.attributes
    assert_redirected_to community_path(assigns(:community))
  end

  test "shouldn't update community whilst not authenticated as a user" do
    put :update, :id => @community.to_param, :community => @community.attributes
    assert_redirected_to new_user_session_path
  end

  ###
  # destroy Tests # TODO Doug/Joe We will want to look at this and decide if it should redirect to a 404 page. -JW
  ###
  test "should not destroy community whilst authenticated as a user" do
    sign_in users(:billy)
    assert_raises(AbstractController::ActionNotFound) do
      assert_no_difference('Community.count') do
        delete :destroy, :id => @community.to_param
      end
      assert_response :missing
    end
  end

  test "should not destroy community whilst not authenticated as a user" do
    assert_raises(AbstractController::ActionNotFound) do
      assert_no_difference('Community.count') do
        delete :destroy, :id => @community.to_param
      end
      assert_response :missing
    end
  end
end
