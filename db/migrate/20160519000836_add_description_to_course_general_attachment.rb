class AddDescriptionToCourseGeneralAttachment < ActiveRecord::Migration
  def change
    add_column :course_general_attachments, :description, :text
  end
end
