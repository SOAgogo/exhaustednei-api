# frozen_string_literal: true

require 'dry-types'
require 'dry-struct'
require_relative '../../shelter_animals/entities/animal'

module PetAdoption
  module Value
    # class Info::adotpers`
    class ShelterInfo < Dry::Struct
      include Dry.Types
      # attribute :animal_area_pkid, Strict::Integer
      attribute :id, Integer.optional
      attribute :origin_id, Strict::Integer
      attribute :name, Strict::String
      attribute :address, Strict::String
      attribute :phone_number, Strict::String
      attribute :cat_number, Strict::Integer
      attribute :dog_number, Strict::Integer
      attribute :animal_number, Strict::Integer
      def to_attr_hash
        to_hash.except(:id, :animal_object_list)
      end
    end
  end
end
