class CreateSongs < ActiveRecord::Migration
  def change
    create_table :songs do |t|
      t.string :name
      t.string :artist_name
      t.string :album_name
      t.integer :playlist_id

      t.timestamps
    end
  end
end
