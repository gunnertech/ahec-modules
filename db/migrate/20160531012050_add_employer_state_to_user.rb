class AddEmployerStateToUser < ActiveRecord::Migration
  def change
    add_column :users, :employer_state, :text
  end
end
