class CreateVideoUploads < ActiveRecord::Migration
  def change
    create_table :video_uploads do |t|
      t.string :hosted_url
      t.references :course, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
