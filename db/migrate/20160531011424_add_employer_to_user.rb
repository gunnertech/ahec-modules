class AddEmployerToUser < ActiveRecord::Migration
  def change
    add_column :users, :employer, :text
  end
end
