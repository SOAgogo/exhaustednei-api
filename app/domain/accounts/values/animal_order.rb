# frozen_string_literal: true

require 'dry-types'
require 'dry-struct'
require_relative '../../shelter_animals/entities/animal'
# module PetAdoption
module PetAdoption
  module Value
    # class PetAdoption::Value::AnimalOrder`
    class AnimalOrder
      def initialize(animal_obj_list = {})
        @animal_order_list = animal_obj_list
      end

      def add_animal(animal)
        @animal_order_list[animal.id] = animal
      end

      def delete_animal(animal_id)
        @animal_order_list.delete(animal_id)
      end
    end
  end
end
