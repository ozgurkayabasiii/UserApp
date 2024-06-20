class CreateAlbumDetails < ActiveRecord::Migration[7.1]
  def change
    create_table :album_details do |t|
      t.string :title
      t.string :url
      t.string :thumbnail_url
      t.references :album, null: false, foreign_key: true

      t.timestamps
    end
  end
end
