class AddTitleDescriptionUrlToCourses < ActiveRecord::Migration
  def change
    add_column :courses, :title, :text
    add_column :courses, :description, :text
    add_column :courses, :videoUrl, :text
  end
end
