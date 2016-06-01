class AddSocialSecurityToUser < ActiveRecord::Migration
  def change
    add_column :users, :social_security, :text
  end
end
