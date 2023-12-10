# frozen_string_literal: true

require 'dry-types'
require 'dry-struct'
require_relative '../../shelter_animals/entities/animals'

module PetAdoption
  module Entity
    # class Info::adotpers`
    class Keepers
      def initialize(animal_keeping_list)
        @animal_keeping_list = animal_keeping_list
      end

      def transfer_animal_to_other_keeper(animal_id, other_keeper)
        @animal_keeping_list.remove(animal_id)
        other_keeper.animal_keeping_list[animal_id] = @animal_keeping_list[animal_id]
      end

      def find_animal_sitter
        # query the user table to find the user who is a sitter
        @animal_keeping_list.each do |animal_id, animal|
          return animal_id if animal.sitter
        end
      end
    end
  end
end
