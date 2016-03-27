class CreateYoutubeVideoIds < ActiveRecord::Migration
  def change
    create_table :youtube_video_ids do |t|
      t.string :video_id

      t.timestamps null: false
    end
  end
end
