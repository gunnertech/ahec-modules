class AddAttachmentDocumentToCourseGeneralAttachments < ActiveRecord::Migration
  def self.up
    change_table :course_general_attachments do |t|
      t.attachment :document
    end
  end

  def self.down
    remove_attachment :course_general_attachments, :document
  end
end
