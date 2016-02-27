class AddNapbAndDobToUser < ActiveRecord::Migration
  def change
    add_column :users, :nabp_id, :string
    add_column :users, :dob, :date
  end
end
