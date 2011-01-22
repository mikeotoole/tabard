require 'test_helper'

class RadioButtonQuestionsControllerTest < ActionController::TestCase
  setup do
    @radio_button_question = radio_button_questions(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:radio_button_questions)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create radio_button_question" do
    assert_difference('RadioButtonQuestion.count') do
      post :create, :radio_button_question => @radio_button_question.attributes
    end

    assert_redirected_to radio_button_question_path(assigns(:radio_button_question))
  end

  test "should show radio_button_question" do
    get :show, :id => @radio_button_question.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @radio_button_question.to_param
    assert_response :success
  end

  test "should update radio_button_question" do
    put :update, :id => @radio_button_question.to_param, :radio_button_question => @radio_button_question.attributes
    assert_redirected_to radio_button_question_path(assigns(:radio_button_question))
  end

  test "should destroy radio_button_question" do
    assert_difference('RadioButtonQuestion.count', -1) do
      delete :destroy, :id => @radio_button_question.to_param
    end

    assert_redirected_to radio_button_questions_path
  end
end
