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
      attr_reader :animal_object_hash, :cat_number, :dog_number

      def initialize
        include Dry.Types
        super
        attribute :animal_area_pkid, Strict::Integer
        attribute :shelter_name, Strict::String
        attribute :shelter_addr, Strict::String
        attribute :shelter_tel, Strict::String
      end
    end
  end
end
