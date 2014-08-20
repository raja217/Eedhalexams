require 'test_helper'

class QuesControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:ques)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create que" do
    assert_difference('Que.count') do
      post :create, :que => { }
    end

    assert_redirected_to que_path(assigns(:que))
  end

  test "should show que" do
    get :show, :id => ques(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => ques(:one).to_param
    assert_response :success
  end

  test "should update que" do
    put :update, :id => ques(:one).to_param, :que => { }
    assert_redirected_to que_path(assigns(:que))
  end

  test "should destroy que" do
    assert_difference('Que.count', -1) do
      delete :destroy, :id => ques(:one).to_param
    end

    assert_redirected_to ques_path
  end
end
