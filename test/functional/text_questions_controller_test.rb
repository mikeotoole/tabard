require 'test_helper'

class TextQuestionsControllerTest < ActionController::TestCase
  setup do
    @text_question = text_questions(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:text_questions)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create text_question" do
    assert_difference('TextQuestion.count') do
      post :create, :text_question => @text_question.attributes
    end

    assert_redirected_to text_question_path(assigns(:text_question))
  end

  test "should show text_question" do
    get :show, :id => @text_question.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @text_question.to_param
    assert_response :success
  end

  test "should update text_question" do
    put :update, :id => @text_question.to_param, :text_question => @text_question.attributes
    assert_redirected_to text_question_path(assigns(:text_question))
  end

  test "should destroy text_question" do
    assert_difference('TextQuestion.count', -1) do
      delete :destroy, :id => @text_question.to_param
    end

    assert_redirected_to text_questions_path
  end
end
