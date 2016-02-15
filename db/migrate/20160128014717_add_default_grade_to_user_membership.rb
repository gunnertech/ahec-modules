class AddDefaultGradeToUserMembership < ActiveRecord::Migration
  def change
    change_column :user_memberships, :course_grade, :decimal, :default => 0
  end
end
