require 'net/http'
require 'digest/md5'

module Rocola
  class Grooveshark
    def initialize()
      @http = Net::HTTP.new('api.grooveshark.com', 443)
      @http.use_ssl = true
    end

    def user_info(username, password)
      authenticate(username, password)
      params = {
        method: 'getUserInfo',
        header: {
          wsKey: ENV['GROOVESHARK_API_KEY'],
          sessionID: ENV['GROOVESHARK_SESSION_ID']
        }
      }
      JSON.parse request(params).body
    end

    def user_subscription_details
      params = {
        method: 'getUserSubscriptionDetails',
        header: {
          wsKey: ENV['GROOVESHARK_API_KEY'],
          sessionID: ENV['GROOVESHARK_SESSION_ID']
        }
      }
      JSON.parse request(params).body
    end

    def start_session
      return @session_id unless @session_id.nil?
      params = {
        method: 'startSession',
        header: {
          wsKey: ENV['GROOVESHARK_API_KEY']
        }
      }
      @session_id = JSON.parse(request(params).body)["result"]["sessionID"]
      @session_id
    end

    def authenticate(username, password)
      params = {
        method: 'authenticate',
        parameters: {
          login: username,
          password: Digest::MD5.hexdigest(password)
        },
        header: {
          wsKey: ENV['GROOVESHARK_API_KEY'],
          sessionID: ENV['GROOVESHARK_SESSION_ID']
        }
      }
      request(params)
    end

    def get_country
      return @country_id unless @country_id.nil?
      params = {
        method: 'getCountry',
        header: {
          wsKey: ENV['GROOVESHARK_API_KEY'],
          sessionID: ENV['GROOVESHARK_SESSION_ID']
        }
      }
      @country_id = JSON.parse(request(params).body)['result']['ID']
      @country_id
    end

    def stream_key_for_song(song_id)
      params = {
        method: 'getStreamKeyStreamServer',
        parameters: {
          songID: song_id,
          country: {
            ID:  "12",
            CC1: "2048",
            CC2: "0",
            CC3: "0",
            CC4: "0",
            DMA: "0",
            IPR: "0"
          },
          lowBitrate: "1"
        },
        header: {
          wsKey: ENV['GROOVESHARK_API_KEY'],
          sessionID: ENV['GROOVESHARK_SESSION_ID']
        }
      }
      JSON.parse(request(params).body)
    end

    def request(params)
      signature = OpenSSL::HMAC.hexdigest('md5', ENV['GROOVESHARK_API_SECRET'], params.to_json)
      @http.post("/ws3.php?sig=#{signature}", params.to_json)
    end

  end
end