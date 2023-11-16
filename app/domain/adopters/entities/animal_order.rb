# frozen_string_literal: true

require 'dry-types'
require 'dry-struct'
require_relative '../../shelter_animals/entities/animal'
# module PetAdoption
module PetAdoption
  module Entity
    # class PetAdoption::Entity::AnimalOrder`
    # when adopters adopt animals, we need to create a new animal order
    # to identify which animal he(she) wants to adopt
    class AnimalOrder
      def initialize(animal_hash)
        @animal_hash = animal_hash
      end
    end
  end
end
