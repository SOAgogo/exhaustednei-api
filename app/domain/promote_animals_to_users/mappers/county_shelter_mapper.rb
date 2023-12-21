# frozen_string_literal: true

require_relative '../entities/animals'
require_relative '../entities/county_shelters'
require_relative '../lib/types'

# create an animal object instance
module PetAdoption
  module Mapper
    # class Info::ShelterMapper`
    class CountyShelterMapper
      attr_reader :shelter_data_list, :shelter_obj_map

      # use repository to get all the shelter info
      def initialize(shelter_data_list)
        @shelter_data_list = shelter_data_list
        @shelter_obj_map = Types::HashedHashes.new
      end

      def set_shelter_obj_map(county_name, shelter_obj)
        shelter_obj_map[county_name][shelter_obj.shelter_info.name] = shelter_obj
      end

      def get_shelter_obj_list(county_name)
        shelter_obj_map[county_name]
      end

      def create_all_shelter_animal_obj(shelter_animal_map)
        shelter_data_list.each do |shelter_info|
          shelter_name = shelter_info['shelter_name']
          county_name = shelter_name[0..2]

          set_shelter_obj_map(county_name,
                              ShelterMapper.find(shelter_info, shelter_animal_map[shelter_name]))
        end
      end

      def shelter_size_in_county(county_name)
        shelter_obj_map[county_name].size
      end

      def build_entity(county_name)
        PetAdoption::Entity::CountyShelter.new(shelter_obj_map[county_name])
      end
    end
  end
end
