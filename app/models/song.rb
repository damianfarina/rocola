class Song < ActiveRecord::Base
	belongs_to :playlist
	
  attr_accessible :album_name, :artist_name, :name, :playlist_id
end
