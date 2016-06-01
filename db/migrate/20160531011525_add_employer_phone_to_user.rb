class AddEmployerPhoneToUser < ActiveRecord::Migration
  def change
    add_column :users, :employer_phone, :text
  end
end
