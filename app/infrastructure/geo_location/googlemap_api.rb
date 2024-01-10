# frozen_string_literal: true

require 'uri'
require 'net/http'
require 'google-maps'
require 'geocoder'

module PetAdoption
  module GeoLocation
    # class Conversation`
    class GoogleMapApi
      class Errors
        SearchDistanceTooShort = Class.new(StandardError)
      end

      DISTANCE_SEARCH_SOURCE = 'https://maps.googleapis.com/maps/api/place/nearbysearch/json'
      attr_reader :county, :current_location, :landmark

      def self.google_map_config
        Google::Maps.configure do |config|
          config.authentication_mode = Google::Maps::Configuration::API_KEY
          config.api_key = App.config.MAP_TOKEN
        end
        Geocoder.configure(
          timeout: 10
        )
      end
      # include PetAdoption::ChineseTranslator::Util

      def self.count_two_points_distance(point1, point2)
        Geocoder::Calculations.distance_between(point1, point2) * 1000
      end

      def initialize(county, landmark)
        GoogleMapApi.google_map_config
        @landmark = landmark
        @county = county
        @current_location = location_right_now
      end

      def longtitude_latitude
        latitude = @current_location.data['lat']
        longitude = @current_location.data['lon']
        [latitude.to_f, longitude.to_f]
      end

      def address
        @current_location.data['display_name']
      end

      def location_right_now
        Geocoder.search("#{@landmark},#{@county}").min_by { |obj| -obj.data['importance'] }
      end

      def find_most_recommendations(distance, top_ratings, type, keyword)
        latitude, longtitude = longtitude_latitude
        location = "#{latitude}%2C#{longtitude}"

        # nearby search api
        res = `curl -L -X GET '#{DISTANCE_SEARCH_SOURCE}?location=#{location}&radius=#{distance}&type=#{type}&keyword=#{keyword}&key=#{App.config.MAP_TOKEN}'` # rubocop:disable Layout/LineLength

        if res == '' || res.include?('ZERO_RESULTS') || res.include?('INVALID_REQUEST')
          return nil, Errors::SearchDistanceTooShort
        end

        res = JSON.parse(res)['results']

        [res.sort_by { |hash| -hash['rating'] }[0...top_ratings], nil]
      end
    end
  end
end
