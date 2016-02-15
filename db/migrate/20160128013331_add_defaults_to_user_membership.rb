class AddDefaultsToUserMembership < ActiveRecord::Migration
  def change
    change_column :user_memberships, :course_attempts, :integer, :default => 0
    change_column :user_memberships, :admin_approved, :boolean, :default => false
  end
end
