class AddPassedOnToUserMembership < ActiveRecord::Migration
  def change
    add_column :user_memberships, :passed_on, :date
  end
end
