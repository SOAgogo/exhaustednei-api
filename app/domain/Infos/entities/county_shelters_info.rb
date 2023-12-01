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
        sum = 0
        binding.pry
        @county_info.each do |_, shelter_info|
          sum += shelter_info.count_num_sterilizations
        end
        sum
      end

      def county_num_no_sterilizations
        sum = 0
        binding.pry
        @county_info.each do |_, shelter_info|
          sum += shelter_info.count_num_no_sterilizations
        end
        sum
      end

      def county_num_animal_bacterin
        sum = 0
        binding.pry
        @county_info.each do |_, shelter_info|
          sum += shelter_info.count_num_animal_bacterin
        end
        sum
      end

      def county_num_animal_no_bacterin
        sum = 0
        binding.pry
        @county_info.each do |_, shelter_info|
          sum += shelter_info.count_num_animal_no_bacterin
        end
        sum
      end
    end
  end
end
