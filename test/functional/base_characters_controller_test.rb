require 'test_helper'

class BaseCharactersControllerTest < ActionController::TestCase
  setup do
    @base_character = base_characters(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:base_characters)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create base_character" do
    assert_difference('BaseCharacter.count') do
      post :create, base_character: @base_character.attributes
    end

    assert_redirected_to base_character_path(assigns(:base_character))
  end

  test "should show base_character" do
    get :show, id: @base_character.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @base_character.to_param
    assert_response :success
  end

  test "should update base_character" do
    put :update, id: @base_character.to_param, base_character: @base_character.attributes
    assert_redirected_to base_character_path(assigns(:base_character))
  end

  test "should destroy base_character" do
    assert_difference('BaseCharacter.count', -1) do
      delete :destroy, id: @base_character.to_param
    end

    assert_redirected_to base_characters_path
  end
end
