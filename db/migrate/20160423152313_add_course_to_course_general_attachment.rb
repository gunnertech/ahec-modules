class AddCourseToCourseGeneralAttachment < ActiveRecord::Migration
  def change
    add_reference :course_general_attachments, :course, index: true, foreign_key: true
  end
end
