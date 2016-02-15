class RenameVideoUrlColumn < ActiveRecord::Migration
  def change
    rename_column :courses, :videoUrl, :video_url
  end
end
