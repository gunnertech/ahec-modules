class AddQuestionJsonToCourses < ActiveRecord::Migration
  def change
    add_column :courses, :question_json, :text
  end
end
