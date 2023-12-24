# frozen_string_literal: true

module PetAdoption
  module Mixins
    # HashIntegers
    module DistanceCalculator
      def distance_between_the_point_and_current_location(point1)
        PetAdoption::GeoLocation::GoogleMapApi.count_two_points_distance(point1, users.google_map.longtitude_latitude)
      end
    end
  end
end
