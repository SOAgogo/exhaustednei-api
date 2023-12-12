# frozen_string_literal: true

require 'dry-types'
require 'dry-struct'
require_relative '../../shelter_animals/entities/animals'
require_relative '../values/takecare_requirements'

module PetAdoption
  module Entity
    # class Info::adotpers`
    class Keepers
      attr_reader :pet_traits, :pet_picture_path

      def initialize(lossing_animals_list, animal_description_list)
        @lossing_animals_list = lossing_animals_list
        @pet_traits = animal_description_list
      end

      # transfer the ownership of the animal to the keeper
      def transfer_animal_to_other_keeper(other_keeper)
        @animal_keeping_list.remove(animal_id)
        other_keeper.animal_keeping_list[animal_id] = @animal_keeping_list[animal_id]
      end

      # watch if there is an animal sitter in database
      def find_animal_sitter(origin_id)
        # query the user table to find the user who is a sitter
        @animal_keeping_list.each do |animal_id, animal|
          return animal if animal_id == origin_id
        end
      end

      def takecare_requirements(animal_introduction)
        @takecare_instr = PetAdoption::Value::TakecareRequirements.new(animal_introduction)
      end
    end
  end
end
