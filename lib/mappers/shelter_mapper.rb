# frozen_string_literal: true

require 'pry'
require_relative '../entities/shelter'

module Info
  # we should create more than one shelterMapper objects?

  # class Info::ShelterMapper`
  class ShelterMapper
    attr_reader :animal_object_hash, :cat_number, :dog_number, :shelter_obj

    # store the shelter hash that can access shelter object

    def initialize
      # @shelter_info = shelter_data
      @shelter_obj = nil
      @animal_object_hash = {}
      @cat_number = 0
      @dog_number = 0
      #   @shelter_list = ShelterList.shelter_animal_parser(@gateway_obj.request_body)
    end

    def set_animal_object_hash(key, value)
      @animal_object_hash[key] = value
    end

    def setting_shelter_obj(shelter_obj)
      @shelter_obj = shelter_obj
    end

    def find(shelter_info)
      DataMapper.new(shelter_info).build_entity
      # @shelter_object_list[shelter_obj.animal_area_pkid] = shelter_obj

      # @animal_object_hash[animal_obj.animal_id] = animal_obj
    end

    def set_cat_number
      @cat_number += 1
    end

    def set_dog_number
      @dog_number += 1
    end

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
          shelter_tel:
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
    end
  end
end
