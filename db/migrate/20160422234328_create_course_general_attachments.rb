class CreateCourseGeneralAttachments < ActiveRecord::Migration
  def change
    create_table :course_general_attachments do |t|

      t.timestamps null: false
    end
  end
end
