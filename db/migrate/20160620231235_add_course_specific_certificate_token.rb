class AddCourseSpecificCertificateToken < ActiveRecord::Migration
  def change
    add_column :courses, :certificate_token, :text
  end
end
