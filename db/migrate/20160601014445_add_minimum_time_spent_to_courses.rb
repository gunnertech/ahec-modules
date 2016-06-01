class AddMinimumTimeSpentToCourses < ActiveRecord::Migration
  def change
    add_column :courses, :minimum_time_spent, :integer, :default => 0

    if Course.last
      last_id = Course.last.id
      batch_size = 10000
      (0..last_id).step(batch_size).each do |from_id|
        to_id = from_id + batch_size
        ActiveRecord::Base.transaction do
          execute <<-SQL
            UPDATE courses
              SET
                minimum_time_spent = 0
              WHERE id BETWEEN #{from_id} AND #{to_id}
              SQL
        end
      end
    end
  end
end
