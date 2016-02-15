class AddTestAttemptsToUserMembership < ActiveRecord::Migration
  def change
    add_column :user_memberships, :course_attempts, :Integer
  end
end
