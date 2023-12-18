# frozen_string_literal: true

require 'pry'
module PetAdoption
  module Mixins
    # HashIntegers
    module DistanceCalculator
      def distance_between_the_point_and_current_location(point1)
        # users.google_map.distance_between(point1, users.google_map.longtitude_latitude) * 1.609344
        PetAdoption::GeoLocation::GoogleMapApi.count_two_points_distance(point1, users.google_map.longtitude_latitude)
      end
    end
  end
end
