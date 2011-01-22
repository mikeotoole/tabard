require 'test_helper'

class ComboBoxQuestionsControllerTest < ActionController::TestCase
  setup do
    @combo_box_question = combo_box_questions(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:combo_box_questions)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create combo_box_question" do
    assert_difference('ComboBoxQuestion.count') do
      post :create, :combo_box_question => @combo_box_question.attributes
    end

    assert_redirected_to combo_box_question_path(assigns(:combo_box_question))
  end

  test "should show combo_box_question" do
    get :show, :id => @combo_box_question.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @combo_box_question.to_param
    assert_response :success
  end

  test "should update combo_box_question" do
    put :update, :id => @combo_box_question.to_param, :combo_box_question => @combo_box_question.attributes
    assert_redirected_to combo_box_question_path(assigns(:combo_box_question))
  end

  test "should destroy combo_box_question" do
    assert_difference('ComboBoxQuestion.count', -1) do
      delete :destroy, :id => @combo_box_question.to_param
    end

    assert_redirected_to combo_box_questions_path
  end
end
