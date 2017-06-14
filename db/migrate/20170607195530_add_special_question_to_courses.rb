class AddSpecialQuestionToCourses < ActiveRecord::Migration
  def change
    add_column :courses, :special_question, :string, :default => "Opinions?"
  end
end
