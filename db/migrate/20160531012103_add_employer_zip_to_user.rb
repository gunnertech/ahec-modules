class AddEmployerZipToUser < ActiveRecord::Migration
  def change
    add_column :users, :employer_zip, :text
  end
end
