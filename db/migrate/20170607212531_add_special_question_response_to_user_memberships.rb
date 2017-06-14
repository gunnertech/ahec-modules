class AddSpecialQuestionResponseToUserMemberships < ActiveRecord::Migration
  def change
    add_column :user_memberships, :special_question_response, :string
  end
end
