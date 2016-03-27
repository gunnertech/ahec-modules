class RemoveYoutubeIdFromCourses < ActiveRecord::Migration
  def change
    remove_column :courses, :video_url
  end
end
