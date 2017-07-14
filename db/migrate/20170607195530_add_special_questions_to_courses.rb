class AddSpecialQuestionsToCourses < ActiveRecord::Migration
  def change
    add_column :courses, :special_questions, :string, :default => "[\"Opinions?\"]"
  end
end
