class AddBalanceToUser < ActiveRecord::Migration
  def change
    add_column :users, :balance, :decimal, :precision => 8, :scale => 2, :default => 0.00
  end
end
