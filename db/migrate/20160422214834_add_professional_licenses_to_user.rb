class AddProfessionalLicensesToUser < ActiveRecord::Migration
  def change
    add_column :users, :professional_licenses, :text
  end
end
