# frozen_string_literal: true

require 'dry-types'
require 'dry-struct'
require_relative 'animal'
module PetAdoption
  module Entity
    # class Info::Shelter`
    class Shelter < Dry::Struct
      include Dry.Types
      # attribute :animal_area_pkid, Strict::Integer
      attribute :id, Integer.optional
      attribute :animal_shelter_pkid, Strict::Integer
      attribute :shelter_name, Strict::String
      attribute :shelter_address, Strict::String
      attribute :shelter_tel, Strict::String
      # add animal object list to shelter
      attribute :animal_object_list, Hash.map(Strict::Integer, Animal)
      # Strict::Hash.map(Strict::Integer, Animal)
      attribute :cat_number, Strict::Integer
      attribute :dog_number, Strict::Integer
      attribute :animal_number, Strict::Integer

      def to_attr_hash
        # to_hash.reject { |key, _| %i[id owner contributors].include? key }
        to_hash.except(:id, :animal_object_list)
      end
    end
  end
end
