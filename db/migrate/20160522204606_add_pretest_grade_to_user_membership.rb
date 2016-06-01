class AddPretestGradeToUserMembership < ActiveRecord::Migration
  def change
    add_column :user_memberships, :pretest_grade, :decimal
  end
end
