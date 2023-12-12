# frozen_string_literal: true

require 'uri'
require 'net/http'
require 'google-maps'
require 'geocoder'

module PetAdoption
  module GeoLocation
    # class Conversation`
    class GoogleMapApi
      PUBLIC_IP_SOURCE = 'https://api.bigdatacloud.net/data/client-ip'
      attr_reader :location

      def self.google_map_config
        Google::Maps.configure do |config|
          config.authentication_mode = Google::Maps::Configuration::API_KEY
          config.api_key = App.config.MAP_TOKEN
        end
      end

      def initialize(location = String.new)
        GoogleMapApi.google_map_config
        @location = location
        @current_location = current_location
        @county = @current_location.data['county']
      end

      def public_ip
        url = URI(PUBLIC_IP_SOURCE)
        http = Net::HTTP.new(url.host, url.port)
        http.use_ssl = true
        request = Net::HTTP::Get.new(url)
        request['accept'] = 'application/json'
        JSON.parse(http.request(request).read_body)['ipString']
      end

      def calculate_desctination_longtitude_latitude
        # Geocoder.search(@location).first.coordinates
        places = Google::Maps.geocode(@location)
        [places.first.latitude, places.first.longitude]
      end

      def current_location
        Geocoder.search(public_ip).first
      end
    end
  end
end
