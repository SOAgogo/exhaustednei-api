# frozen_string_literal: true

module PetAdoption
  module Mixins
    # Mixin for calculating time difference
    module TimeDifferenceCalculator
      def calculate_time_difference(animal_obj)
        (Time.parse(DateTime.now.to_s) -
         Time.parse(animal_obj.feature['registration_date'].to_s)) / (60 * 60 * 24).round
      end
    end
  end
end
