require 'test_helper'

class RegistrationAnswersControllerTest < ActionController::TestCase
  setup do
    @registration_answer = registration_answers(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:registration_answers)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create registration_answer" do
    assert_difference('RegistrationAnswer.count') do
      post :create, :registration_answer => @registration_answer.attributes
    end

    assert_redirected_to registration_answer_path(assigns(:registration_answer))
  end

  test "should show registration_answer" do
    get :show, :id => @registration_answer.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @registration_answer.to_param
    assert_response :success
  end

  test "should update registration_answer" do
    put :update, :id => @registration_answer.to_param, :registration_answer => @registration_answer.attributes
    assert_redirected_to registration_answer_path(assigns(:registration_answer))
  end

  test "should destroy registration_answer" do
    assert_difference('RegistrationAnswer.count', -1) do
      delete :destroy, :id => @registration_answer.to_param
    end

    assert_redirected_to registration_answers_path
  end
end
