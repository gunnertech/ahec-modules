class AddReferencesToYoutubeVideoIds < ActiveRecord::Migration
  def change
    add_reference :youtube_video_ids, :course, index: true, foreign_key: true
  end
end
