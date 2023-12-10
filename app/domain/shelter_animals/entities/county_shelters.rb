# frozen_string_literal: true

require_relative '../values/shelter_info_stats'

module PetAdoption
  module Entity
    # class Info::adotpers`
    class CountyShelter
      attr_reader :county_shelter_list

      def initialize(county_info)
        @county_shelter_list = county_info
      end

      def caculate_each_shelter_severity_of_old_animals
        @county_shelter_list.reduce(0) do |sum, (_, shelter)|
          sum += 1 if shelter.shelter_stats.severity_of_old_animals == 'severe'
          sum
        end
      end

      def county_severity_of_old_animals
        ratio = caculate_each_shelter_severity_of_old_animals / county_shelter_list.size * 100
        'severe' if ratio > 50
        'moderate' if ratio > 20
        'mild'
      end
    end
  end
end
