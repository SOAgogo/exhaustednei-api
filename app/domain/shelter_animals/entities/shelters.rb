# frozen_string_literal: true

require 'dry-types'
require 'dry-struct'
require_relative 'animals'
require_relative '../values/shelter_info_stats'
require_relative '../lib/types'
require 'pry'
module PetAdoption
  module Entity
    # class Info::Shelter`
    class Shelter
      def initialize(shelter_info, animal_obj_list)
        @shelter_info = Value::ShelterInfo.new(shelter_info)
        @shelter_stats = Value::ShelterStats.new(animal_obj_list)
        @animal_object_list = Types::HashedAnimals.new(animal_obj_list)
      end

      def promote_to_user
        animal_object_list.values.map(&:promote_to_user)
      end

      def show_the_chart
        animal_object_list.values.map(&:show_the_chart)
      end
    end
  end
end
