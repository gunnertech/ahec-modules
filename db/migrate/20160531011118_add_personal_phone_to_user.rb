class AddPersonalPhoneToUser < ActiveRecord::Migration
  def change
    add_column :users, :personal_phone, :text
  end
end
