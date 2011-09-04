require 'test_helper'

class SwtorCharactersControllerTest < ActionController::TestCase
  setup do
    @swtor_character = swtor_characters(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:swtor_characters)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create swtor_character" do
    assert_difference('SwtorCharacter.count') do
      post :create, swtor_character: @swtor_character.attributes
    end

    assert_redirected_to swtor_character_path(assigns(:swtor_character))
  end

  test "should show swtor_character" do
    get :show, id: @swtor_character.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @swtor_character.to_param
    assert_response :success
  end

  test "should update swtor_character" do
    put :update, id: @swtor_character.to_param, swtor_character: @swtor_character.attributes
    assert_redirected_to swtor_character_path(assigns(:swtor_character))
  end

  test "should destroy swtor_character" do
    assert_difference('SwtorCharacter.count', -1) do
      delete :destroy, id: @swtor_character.to_param
    end

    assert_redirected_to swtor_characters_path
  end
end
