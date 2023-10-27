# frozen_string_literal: true

require 'dry-types'
require 'dry-struct'

# verify your identification

# --- TODO: delete the shelterList below ---
module Info
  # class Info::ShelterList`
  module Entity
    # class Info::Shelter`
    class Shelter < Dry::Struct
      attr_reader :animal_object_hash

      def initialize
        include Dry.Types
        super
        attribute :animal_object_hash, Hash
        attribute :cat_number, Strict::Integer
        attribute :dog_number, Strict::Integer
      end

      def set_animal_object_hash
        @animal_object_hash
      end
    end
  end
end
