# frozen_string_literal: true

require 'pry'
require_relative '../entities/shelter'
# create an shelter object instance
module Info
  # class Info::ShelterMapper`
  # we should create more than one shelterMapper objects?
  class ShelterMapper
    # attr_reader :animal_object_list

    # store the shelter hash that can access shelter object

    def initialize
      # @shelter_info = shelter_data
      # @shelter_object_list = {}
      #   @shelter_list = ShelterList.shelter_animal_parser(@gateway_obj.request_body)
    end

    # def set_shelter_object
    #   @shelter_object_list
    # end

    def find(shelter_info)
      DataMapper.new(shelter_info).build_entity
      # @shelter_object_list[shelter_obj.animal_area_pkid] = shelter_obj

      # @animal_object_hash[animal_obj.animal_id] = animal_obj
    end

    # def set_animal_object_list(key, value)
    #   @shelter_object_list[key] = value
    # end

    # AnimalMapper::DataMapper
    # ShelterMapper::DataMapper
    class DataMapper
      def initialize(shelter_data)
        @data = shelter_data
      end

      def build_entity
        Entity::Shelter.new(
          # @animal_attributes
          animal_area_pkid:,
          animal_shelter_pkid:,
          shelter_name:,
          shelter_address:,
          shelter_tel:,
          cat_number:,
          dog_number:,
          animal_object_list:
        )
      end

      private

      def animal_area_pkid
        @data['animal_area_pkid']
      end

      def animal_shelter_pkid
        @data['animal_shelter_pkid']
      end

      def shelter_name
        @data['shelter_name']
      end

      def shelter_address
        @data['shelter_address']
      end

      def shelter_tel
        @data['shelter_tel']
      end

      def cat_number
        0
      end

      def dog_number
        0
      end

      def animal_object_list
        {}
      end
    end
  end
end
