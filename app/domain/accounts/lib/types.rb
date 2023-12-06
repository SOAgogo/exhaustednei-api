# frozen_string_literal: true

module PetAdoption
  module Types
    # HashIntegers
    class HashedIntegers
      def self.new
        Hash.new { |hash, key| hash[key] = 0 }
      end
    end
  end
end
