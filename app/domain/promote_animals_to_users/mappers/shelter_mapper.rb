# frozen_string_literal: true

require_relative '../entities/shelters'
require_relative '../entities/animals'
require 'pry'
module PetAdoption
  module Mapper
    # class Info::ShelterMapper`
    class ShelterMapper
      attr_reader :shelter_info_list

      # store the shelter hash that can access shelter object
      def initialize(shelter_info_list)
        @shelter_info_list = shelter_info_list
      end

      def self.find(shelter_info, animal_map)
        DataMapper.new(shelter_info, animal_map).build_entity
      end

      # # ShelterMapper::DataMapper
      class DataMapper
        def initialize(shelter_data, animal_map)
          @data = shelter_data
          @animal_map = animal_map
        end

        def build_entity
          PetAdoption::Entity::Shelter.new(
            {
              origin_id:,
              name:,
              address:,
              phone_number:
            },
            animal_object_list
          )
        end

        private

        def origin_id
          @data['animal_shelter_pkid']
        end

        def name
          @data['shelter_name']
        end

        def address
          @data['shelter_address']
        end

        def phone_number
          @data['shelter_tel']
        end

        def animal_object_list
          @animal_map
        end
      end
    end
  end
end
