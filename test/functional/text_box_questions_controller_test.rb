require 'test_helper'

class TextBoxQuestionsControllerTest < ActionController::TestCase
  setup do
    @text_box_question = text_box_questions(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:text_box_questions)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create text_box_question" do
    assert_difference('TextBoxQuestion.count') do
      post :create, :text_box_question => @text_box_question.attributes
    end

    assert_redirected_to text_box_question_path(assigns(:text_box_question))
  end

  test "should show text_box_question" do
    get :show, :id => @text_box_question.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @text_box_question.to_param
    assert_response :success
  end

  test "should update text_box_question" do
    put :update, :id => @text_box_question.to_param, :text_box_question => @text_box_question.attributes
    assert_redirected_to text_box_question_path(assigns(:text_box_question))
  end

  test "should destroy text_box_question" do
    assert_difference('TextBoxQuestion.count', -1) do
      delete :destroy, :id => @text_box_question.to_param
    end

    assert_redirected_to text_box_questions_path
  end
end
