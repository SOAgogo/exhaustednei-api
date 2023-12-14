# frozen_string_literal: true

module PetAdoption
  module Mixins
    # HashIntegers
    module DistanceCalculator
      def distance_between_the_point_and_current_location(point1)
        users.google_map.distance_between(point1, users.longtiude_latitude) * 1.609344
      end
    end
  end
end
