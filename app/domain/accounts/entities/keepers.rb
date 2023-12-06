# frozen_string_literal: true

require 'dry-types'
require 'dry-struct'
require_relative '../../shelter_animals/entities/animal'

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
        
      end
    end
  end
end
