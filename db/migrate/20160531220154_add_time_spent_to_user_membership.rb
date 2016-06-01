class AddTimeSpentToUserMembership < ActiveRecord::Migration
  def change
    add_column :user_memberships, :minutes_spent, :integer, :default => 0

    if UserMembership.last
      last_id = UserMembership.last.id
      batch_size = 10000
      (0..last_id).step(batch_size).each do |from_id|
        to_id = from_id + batch_size
        ActiveRecord::Base.transaction do
          execute <<-SQL
            UPDATE user_memberships
              SET
                minutes_spent = 0
              WHERE id BETWEEN #{from_id} AND #{to_id}
              SQL
        end
      end
    end
  end
end
