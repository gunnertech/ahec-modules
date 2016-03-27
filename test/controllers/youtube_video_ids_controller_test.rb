require 'test_helper'

class YoutubeVideoIdsControllerTest < ActionController::TestCase
  setup do
    @youtube_video_id = youtube_video_ids(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:youtube_video_ids)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create youtube_video_id" do
    assert_difference('YoutubeVideoId.count') do
      post :create, youtube_video_id: { id: @youtube_video_id.id }
    end

    assert_redirected_to youtube_video_id_path(assigns(:youtube_video_id))
  end

  test "should show youtube_video_id" do
    get :show, id: @youtube_video_id
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @youtube_video_id
    assert_response :success
  end

  test "should update youtube_video_id" do
    patch :update, id: @youtube_video_id, youtube_video_id: { id: @youtube_video_id.id }
    assert_redirected_to youtube_video_id_path(assigns(:youtube_video_id))
  end

  test "should destroy youtube_video_id" do
    assert_difference('YoutubeVideoId.count', -1) do
      delete :destroy, id: @youtube_video_id
    end

    assert_redirected_to youtube_video_ids_path
  end
end
