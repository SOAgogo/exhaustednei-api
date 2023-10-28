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
      attr_reader :animal_object_list, :cat_number, :dog_number

      def initialize
        include Dry.Types
        super
        attribute :animal_area_pkid, Strict::Integer
        attribute :shelter_name, Strict::String
        attribute :shelter_addr, Strict::String
        attribute :shelter_tel, Strict::String
        attribute :cat_number, Strict::Integer
        attribute :dog_number, Strict::Integer
        attribute :animal_object_list, Strict::Hash
      end

      def set_animal_object_list(key, value)
        @animal_object_list[key] = value
      end

      def set_cat_number
        @cat_number += 1
      end

      def set_dog_number
        @dog_number += 1
      end
    end
  end
end
