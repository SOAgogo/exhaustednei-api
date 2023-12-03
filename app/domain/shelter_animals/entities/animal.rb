# frozen_string_literal: true

# verify your identification
require 'dry-types'
require 'dry-struct'
module PetAdoption
  module Entity
    # class Info::Animal`
    class Animal < Dry::Struct
      # attr_reader :animal_id, :animal_area_pkid, :animal_shelter_pkid, :shelter_name, :shelter_address, :shelter_tel
      include Dry.Types
      attribute :id,        Integer.optional
      attribute :animal_id, Strict::Integer
      attribute :animal_kind, Strict::String
      attribute :animal_variate, String.optional
      attribute :animal_age, Strict::String
      attribute :animal_color, Strict::String
      attribute :animal_sex, Strict::String
      attribute :animal_sterilization, Strict::Bool
      attribute :animal_bacterin, Strict::Bool
      attribute :animal_bodytype, Strict::String
      attribute :animal_found_place, Strict::String
      attribute :album_file, String.optional
      attribute :animal_place, Strict::String
      attribute :animal_opendate, String.optional

      def to_attr_hash
        to_hash.except(:id)
      end

      def to_decode_hash
        to_hash.except(:animal_kind,
                       :animal_variate,
                       :animal_found_place,
                       :animal_age,
                       :animal_color,
                       :animal_place)
      end
    end

    # class Info::Cat`
    class Cat < Animal

    end

    # class Info::Dog`
    class Dog < Animal

    end
  end
end
