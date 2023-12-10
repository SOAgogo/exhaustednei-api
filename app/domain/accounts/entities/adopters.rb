# frozen_string_literal: true

require_relative 'accounts'
require_relative '../values/animal_order'
require_relative '../../shelter_animals/entities/animals'
module PetAdoption
  module Entity
    # class Info::adotpers`
    class Adopters
      def initialize(animal_favorite_list, user_preference)
        @animal_favorite_list = animal_favorite_list
        @user_preference = user_preference # user preference is like hair=red, age=young
        @confirm_order = PetAdoption::Value::AnimalOrder.new
      end

      def to_attr_hash
        @accounts.to_attr_hash
      end

      def self.delete_order_item(animal_id)
        @animal_order.delete(animal_id)
      end

      def self.add_order_item(animal)
        @animal_order.add_animal(animal)
      end
    end
  end
end
