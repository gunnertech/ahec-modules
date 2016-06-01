class AddEmployerAddressToUser < ActiveRecord::Migration
  def change
    add_column :users, :employer_address, :text
  end
end
