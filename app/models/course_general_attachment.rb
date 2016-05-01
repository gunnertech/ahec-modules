class CourseGeneralAttachment < ActiveRecord::Base
  belongs_to :course
  has_attached_file :document
  validates_attachment_file_name :document, matches: [/pdf\Z/, /doc\Z/, /docx\Z/, /ppt\Z/, /pptx\Z/, /txt\Z/]
end
