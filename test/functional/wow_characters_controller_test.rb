require 'test_helper'

class WowCharactersControllerTest < ActionController::TestCase
  setup do
    @wow_character = wow_characters(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:wow_characters)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create wow_character" do
    assert_difference('WowCharacter.count') do
      post :create, wow_character: @wow_character.attributes
    end

    assert_redirected_to wow_character_path(assigns(:wow_character))
  end

  test "should show wow_character" do
    get :show, id: @wow_character.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @wow_character.to_param
    assert_response :success
  end

  test "should update wow_character" do
    put :update, id: @wow_character.to_param, wow_character: @wow_character.attributes
    assert_redirected_to wow_character_path(assigns(:wow_character))
  end

  test "should destroy wow_character" do
    assert_difference('WowCharacter.count', -1) do
      delete :destroy, id: @wow_character.to_param
    end

    assert_redirected_to wow_characters_path
  end
end
