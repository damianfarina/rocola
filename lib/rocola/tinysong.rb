module Rocola
  module Tinysong
    class Search
      attr_accessor :keyword
      attr_accessor :songs

      def initialize(attributes={})
        @keyword = attributes[:keyword] if attributes[:keyword].present?
      end

      def keyword=(value)
        @keyword = value
      end

      def keyword
        @keyword
      end

      def songs=(value)
        @songs = value if value.is_a? Array
      end

      def songs
        @songs || []
      end

      def search
        return [] if @keyword.nil?
        @songs = Song.parse(API.search(@keyword))
        @songs
      end

      def self.model_name
        self
      end

      def self.param_key
        "search"
      end

      def to_key
        [:keyword]
      end

    end

    class Song
      attr_accessor :id, :artist_name, :album_name, :song_name, :url, :artist_id

      def initialize(attributes=nil)
        @artist_name = attributes[:artist_name]
        @album_name = attributes[:album_name]
        @song_name = attributes[:song_name]
        @url = attributes[:url]
        @id = attributes[:id]
        @artist_id = attributes[:artist_id]
      end

      def self.parse(json)
        songs = []
        json.each do |js|
          songs << Song.new(:artist_name => js["ArtistName"], :album_name => js["AlbumName"], :song_name => js["SongName"], :url => js["Url"], :id => js["SongID"], :artist_id => js["ArtistId"])
        end
        songs
      end
    end

    class API
      def self.search(keyword)
        @http = Net::HTTP.new('tinysong.com', 80)
        params = {"format" => 'json', "key" => ENV['TINYSONG_API_KEY'], 'limit' => '50'}
        JSON.parse @http.get("/s/#{URI.escape keyword}?#{params.to_query}").body
      end
    end

  end
end