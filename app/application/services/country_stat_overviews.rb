# frozen_string_literal: true

require 'dry/transaction'

module PetAdoption
  module Services
    # class CreateUserAccounts`
    class CountryOverView
      include Dry::Transaction

      # def initialize(cookie_hash)
      #   @cookie_hash = cookie_hash
      # end
      step :fetch_all_county_data
      step :assemble_all_county_data
      step :get_final_stats

      private

      def fetch_all_county_data
        shelter = PetAdoption::ShelterInfo::CountryShelterMapper.build_entity
        if shelter.country_info.empty?
          Failure('CountryInfo entity creation failed')
        else
          Success(shelter:)
        end
      end

      def assemble_all_county_data(shelter)
        county_stats = {}
        shelter = shelter[:shelter]
        total_sterilization = 0
        total_no_sterilization = 0
        total_num_bacterin = 0
        total_no_sterilization = 0
        shelter.each do |city, county_shelter_stats|
          record_hash = {}
          record_hash['no_sterilizations'] = county_shelter_stats.county_num_no_sterilizations
          record_hash['sterilizations'] = county_shelter_stats.county_num_sterilizations
          record_hash['animal_bacterin'] = county_shelter_stats.county_num_animal_bacterin
          record_hash['no_animal_bacterin'] = county_shelter_stats.county_num_animal_no_bacterin
          county_stats[city] = record_hash
        end

        Success(county_stats)
      end

      def get_final_stats(county_stats)
        final_stats = {}
        county_stats = county_stats[:county_stats]
        total_sterilization = 0
        total_no_sterilization = 0
        total_num_bacterin = 0
        total_no_sterilization = 0
        county_stats.each do |_city, county_shelter_stats|
          total_sterilization += county_shelter_stats['sterilizations']
          total_no_sterilization += county_shelter_stats['no_sterilizations']
          total_num_bacterin += county_shelter_stats['animal_bacterin']
          total_no_sterilization += county_shelter_stats['no_animal_bacterin']
        end
        final_stats['total_sterilization'] = total_sterilization
        final_stats['total_no_sterilization'] = total_no_sterilization
        final_stats['total_num_bacterin'] = total_num_bacterin
        final_stats['total_no_sterilization'] = total_no_sterilization
        Success(final_stats:, county_stats:)
      end
    end
  end
end
