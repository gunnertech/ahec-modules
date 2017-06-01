class AddCostToCourse < ActiveRecord::Migration
  def change
    add_column :courses, :cost, :decimal, :precision => 8, :scale => 2, :default => 0.00
  end
end
