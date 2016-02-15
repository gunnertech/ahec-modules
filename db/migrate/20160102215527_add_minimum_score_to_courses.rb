class AddMinimumScoreToCourses < ActiveRecord::Migration
  def change
    add_column :courses, :minimum_score, :Integer
  end
end
