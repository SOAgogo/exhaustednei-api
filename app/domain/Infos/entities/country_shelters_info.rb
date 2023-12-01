# frozen_string_literal: true

require_relative 'shelters_info'
require_relative 'county_shelters_info'
require 'pry'

module PetAdoption
  module Entity
    # class Info::adotpers`
    class CountryShelterStats
      attr_reader :country_info

      def initialize(country_info)
        @country_info = country_info
      end

      def country_num_sterilizations
        sum = 0
        @country_info.each do |_, county_info|
          sum += county_info.county_num_sterilizations
        end
        sum
      end

      def country_num_no_sterilizations
        sum = 0
        @country_info.each do |_, county_info|
          sum += county_info.county_num_no_sterilizations
        end
        sum
      end

      def country_num_animal_bacterin
        sum = 0
        @country_info.each do |_, county_info|
          sum += county_info.county_num_animal_bacterin
        end
        sum
      end

      def country_num_animal_no_bacterin
        sum = 0
        @country_info.each do |_, county_info|
          sum += county_info.county_num_animal_no_bacterin
        end
        sum
      end
    end
  end
end
