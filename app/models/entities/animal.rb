# frozen_string_literal: true

# verify your identification
require 'dry-types'
require 'dry-struct'
module Entity
  # class Info::Animal`
  class Animal < Dry::Struct
    # attr_reader :animal_id, :animal_area_pkid, :animal_shelter_pkid, :shelter_name, :shelter_address, :shelter_tel
    include Dry.Types
    attribute :id,        Integer.optional
    attribute :animal_id, Strict::Integer
    attribute :animal_kind, Strict::String
    attribute :animal_variate, String.optional
    attribute :animal_sex, Strict::String
    attribute :animal_sterilization, Strict::Bool
    attribute :animal_bacterin, Strict::Bool
    attribute :animal_bodytype, Strict::String
    attribute :album_file, String.optional
    attribute :animal_place, Strict::String
    attribute :animal_opendate, String.optional
  end

  # class Info::Cat`
  class Cat < Animal
    include Dry.Types
  end

  # class Info::Dog`
  class Dog < Animal
    include Dry.Types
  end
end
