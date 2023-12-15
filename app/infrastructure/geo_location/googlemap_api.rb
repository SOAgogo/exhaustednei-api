# frozen_string_literal: true

require 'uri'
require 'net/http'
require 'google-maps'
require 'geocoder'
require 'pry'
require_relative '../lib/chinese_translator'

module PetAdoption
  module GeoLocation
    # class Conversation`
    class GoogleMapApi
      PUBLIC_IP_SOURCE = 'https://api.bigdatacloud.net/data/client-ip'
      DISTANCE_SEARCH_SOURCE = 'https://maps.googleapis.com/maps/api/place/nearbysearch/json'
      attr_reader :county, :current_location

      def self.google_map_config
        Google::Maps.configure do |config|
          config.authentication_mode = Google::Maps::Configuration::API_KEY
          config.api_key = App.config.MAP_TOKEN
        end
      end
      include PetAdoption::ChineseTranslator::Util

      def initialize(location = String.new)
        GoogleMapApi.google_map_config
        @location = location
        @current_location = location_right_now
        @county = translate_county_to_chinese(@current_location.data['city'])
      end

      def longtitude_latitude
        latitude, longitude = @current_location.data['loc'].split(',')
        [latitude, longitude]
      end

      def public_ip
        url = URI(PUBLIC_IP_SOURCE)
        http = Net::HTTP.new(url.host, url.port)
        http.use_ssl = true
        request = Net::HTTP::Get.new(url)
        request['accept'] = 'application/json'
        JSON.parse(http.request(request).read_body)['ipString']
      end

      def calculate_destination_longtitude_latitude
        # Geocoder.search(@location).first.coordinates
        places = Google::Maps.geocode(@location)
        [places.first.latitude, places.first.longitude]
      end

      def location_right_now
        Geocoder.search(public_ip).first
      end

      def find_most_recommendations(distance, top_ratings, type, keyword)
        latitude, longtitude = longtitude_latitude
        location = "#{latitude}%2C#{longtitude}"
        # type = 'veterinary_care'
        # keyword = 'pet%20clinic'

        res = `curl -L -X GET '#{DISTANCE_SEARCH_SOURCE}?location=#{location}&radius=#{distance}&type=#{type}&keyword=#{keyword}&key=AIzaSyATOozXnKChk0k5eLSum2NylBwk0Jtu_ZQ'`
        res = JSON.parse(res)['results']
        res.sort_by { |hash| -hash['rating'] }[0...top_ratings]
      end
    end
  end
end
