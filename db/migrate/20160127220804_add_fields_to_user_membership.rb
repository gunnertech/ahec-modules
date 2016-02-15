class AddFieldsToUserMembership < ActiveRecord::Migration
  def change
    add_column :user_memberships, :admin_approved, :boolean
    add_column :user_memberships, :course_grade, :decimal
  end
end
