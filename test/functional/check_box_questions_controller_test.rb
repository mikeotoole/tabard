require 'test_helper'

class CheckBoxQuestionsControllerTest < ActionController::TestCase
  setup do
    @check_box_question = check_box_questions(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:check_box_questions)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create check_box_question" do
    assert_difference('CheckBoxQuestion.count') do
      post :create, :check_box_question => @check_box_question.attributes
    end

    assert_redirected_to check_box_question_path(assigns(:check_box_question))
  end

  test "should show check_box_question" do
    get :show, :id => @check_box_question.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @check_box_question.to_param
    assert_response :success
  end

  test "should update check_box_question" do
    put :update, :id => @check_box_question.to_param, :check_box_question => @check_box_question.attributes
    assert_redirected_to check_box_question_path(assigns(:check_box_question))
  end

  test "should destroy check_box_question" do
    assert_difference('CheckBoxQuestion.count', -1) do
      delete :destroy, :id => @check_box_question.to_param
    end

    assert_redirected_to check_box_questions_path
  end
end
