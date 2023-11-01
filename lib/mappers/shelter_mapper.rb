# frozen_string_literal: true

require 'pry'
require_relative '../entities/shelter'

module Info
  # we should create more than one shelterMapper objects?

  # class Info::ShelterMapper`
  class ShelterMapper
    attr_reader :shelter_obj_map, :shelter_info_list

    # store the shelter hash that can access shelter object

    def initialize(shelter_info_list)
      @shelter_info_list = shelter_info_list
      @shelter_obj_map = {}
    end

    def set_shelter_obj_map(shelter_id, shelter_obj)
      @shelter_obj_map[shelter_id] = shelter_obj
    end

    def shelter_size
      @shelter_obj_map.size
    end

    def create_all_shelter_animal_obj(shelter_animal_map)
      @shelter_info_list.each do |shelter_info|
        shelter_animal_map.each do |shelter_id, animal_list|
          set_shelter_obj_map(shelter_id, find(shelter_info, animal_list))
          # @shelter_obj_map[shelter_id] = find(shelter_info, animal_list)
        end
      end
    end

    def calculate_dog_nums
      num = 0
      @shelter_obj_map.each do |_, shelter_obj|
        num += shelter_obj.dog_number
      end
      num
    end

    def calculate_cat_nums
      num = 0
      @shelter_obj_map.each do |_, shelter_obj|
        num += shelter_obj.cat_number
      end
      num
    end

    def find_animal_in_shelter(shelter_id, animal_id)
      @shelter_obj_map[shelter_id].animal_object_list[animal_id]
    end

    def animal_size_in_shelter(rand_shelter_id)
      @shelter_obj_map[rand_shelter_id].animal_number
    end

    def find(shelter_info, animal_list)
      DataMapper.new(shelter_info, animal_list).build_entity
      # @shelter_object_list[shelter_obj.animal_area_pkid] = shelter_obj

      # @animal_object_hash[animal_obj.animal_id] = animal_obj
    end

    # AnimalMapper::DataMapper
    # ShelterMapper::DataMapper
    class DataMapper
      def initialize(shelter_data, animal_list)
        @data = shelter_data
        @animal_list = animal_list
      end

      def build_entity
        Entity::Shelter.new(
          # @animal_attributes
          animal_shelter_pkid:,
          shelter_name:,
          shelter_address:,
          shelter_tel:,
          animal_object_list:,
          cat_number:,
          dog_number:,
          animal_number:
        )
      end

      private

      # def animal_area_pkid
      #   @data['animal_area_pkid']
      # end

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

      def animal_object_list
        animal_object_list = {}
        @animal_list.each do |animal|
          animal_object_list[animal.animal_id] = animal
        end
        # binding.pry
        animal_object_list
      end

      def cat_number
        cat_number = 0
        @animal_list.each do |animal|
          cat_number += 1 if animal.sound == 'meow'
        end
        cat_number
      end

      def dog_number
        dog_number = 0
        @animal_list.each do |animal|
          dog_number += 1 if animal.sound == 'woof'
        end
        dog_number
      end

      def animal_number
        @animal_list.size
      end
    end
  end
end
