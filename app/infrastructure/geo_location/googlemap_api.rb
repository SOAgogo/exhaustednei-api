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
      DISTANCE_SEARCH_SOURCE = 'https://maps.googleapis.com/maps/api/place/nearbysearch/json'
      attr_reader :county, :current_location, :landmark

      def self.google_map_config
        Google::Maps.configure do |config|
          config.authentication_mode = Google::Maps::Configuration::API_KEY
          config.api_key = App.config.MAP_TOKEN
        end
      end
      # include PetAdoption::ChineseTranslator::Util

      def self.count_two_points_distance(point1, point2)
        Geocoder::Calculations.distance_between(point1, point2) * 1.609344
      end

      def initialize(county, landmark)
        GoogleMapApi.google_map_config
        @landmark = landmark
        @county = county
        @current_location = location_right_now
        # @county = translate_county_to_chinese(@current_location.data['city'])
        # @county = @current_location.data['city']
      end

      def longtitude_latitude
        latitude = @current_location.data['lat']
        longitude = @current_location.data['lon']
        [latitude.to_f, longitude.to_f]
      end

      def location_right_now
        Geocoder.search("#{@landmark},#{@county}").min_by { |obj| -obj.data['importance'] }
      end

      def find_most_recommendations(_distance, top_ratings, _type, _keyword)
        latitude, longtitude = longtitude_latitude
        location = "#{latitude}%2C#{longtitude}"

        res = `curl -L -X GET '#{DISTANCE_SEARCH_SOURCE}?location=#{location}&radius=#{distance}&
        type=#{type}&keyword=#{keyword}&key=#{MAP_TOKEN}'`
        res = JSON.parse(res)['results']
        res.sort_by { |hash| -hash['rating'] }[0...top_ratings]
      end
    end
  end
end
