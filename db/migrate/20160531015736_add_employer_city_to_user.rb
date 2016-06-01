class AddEmployerCityToUser < ActiveRecord::Migration
  def change
    add_column :users, :employer_city, :text
  end
end
