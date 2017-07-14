class AddSpecialQuestionsResponsesToUserMemberships < ActiveRecord::Migration
  def change
    add_column :user_memberships, :special_questions_responses, :string
  end
end
