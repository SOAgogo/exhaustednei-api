# frozen_string_literal: true

require 'dry-types'
require 'dry-struct'
require_relative '../../shelter_animals/entities/animals'
# module PetAdoption
module PetAdoption
  module Value
    # class AnimalTraits`
    class AnimalTraits
      def initialize(animal_traits)
        @animal_traits = animal_traits
      end
    end
  end
end
