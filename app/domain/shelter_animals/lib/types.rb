# frozen_string_literal: true

module PetAdoption
  module Types
    # Hash type that returns empty array when key not found
    class HashedAnimals
      def self.new(animal_obj)
        Hash.new { |hash, key| hash[key] = animal_obj }
      end
    end

    # Hash type that returns 0 when key not found
    class HashedShelters
      def self.new(shelter_obj)
        Hash.new { |hash, key| hash[key] = shelter_obj }
      end
    end
  end
end
