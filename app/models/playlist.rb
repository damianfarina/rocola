class Playlist < ActiveRecord::Base
	has_one :current_song, :class_name => "Song"
	has_many :songs, :dependent => :destroy
	
  attr_accessible :current_song_id, :name
end
