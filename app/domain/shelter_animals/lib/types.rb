# frozen_string_literal: true

module PetAdoption
  module Types
    # Hash type that returns empty array when key not found
    class HashedArrays
      def self.new
        Hash.new { |hash, key| hash[key] = Entity::Animal.new }
      end
    end

    # Hash type that returns 0 when key not found
    class HashedIntegers
      def self.new
        Hash.new { |hash, key| hash[key] = 0 }
      end
    end
  end
end
