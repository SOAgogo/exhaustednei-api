# frozen_string_literal: true

require 'dry-types'
require 'dry-struct'
require_relative '../../shelter_animals/entities/animal'
# module PetAdoption
module PetAdoption
  module Value
    # class PetAdoption::Entity::AnimalOrder`
    # when adopters adopt animals, we need to create a new animal order
    # to identify which animal he(she) wants to adopt
    class ShelterOrder
      def initialize(_animal_order = PetAdoption::Entity::AnimalOrder.new)
        @shelter = shelter
        @animal_order_list = []
      end
    end
  end
end
