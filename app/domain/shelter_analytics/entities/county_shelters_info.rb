# frozen_string_literal: true

require_relative 'shelters_info'

module PetAdoption
  module Entity
    # class Info::adotpers`
    class CountyShelterStats
      attr_reader :county_info

      def initialize(county_info)
        @county_info = county_info
      end

      def county_num_sterilizations
        @county_info.reduce(0) do |sum, (_, shelter_info)|
          sum + shelter_info.count_num_sterilizations
        end
      end

      def county_num_no_sterilizations
        @county_info.reduce(0) do |sum, (_, shelter_info)|
          sum + shelter_info.count_num_no_sterilizations
        end
      end

      def county_num_animal_bacterin
        @county_info.reduce(0) do |sum, (_, shelter_info)|
          sum + shelter_info.count_num_animal_bacterin
        end
      end

      def county_num_animal_no_bacterin
        @county_info.reduce(0) do |sum, (_, shelter_info)|
          sum + shelter_info.count_num_animal_no_bacterin
        end
      end
    end
  end
end
