# frozen_string_literal: true
module PetAdoption
  module Mixins
    module TimeDifferenceCalculator
      def calculate_time_difference
        time_difference = ((Time.parse(DateTime.now().to_s) - Time.parse(animal_obj.registration_date.to_s))/(60*60*24)).round()
      end
    end
  end
end
