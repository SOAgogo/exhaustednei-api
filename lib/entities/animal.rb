# frozen_string_literal: true

# verify your identification
require 'dry-types'
require 'dry-struct'
module Entity
  # class Info::Animal`
  class Animal < Dry::Struct
    # attr_reader :animal_id, :animal_area_pkid, :animal_shelter_pkid, :shelter_name, :shelter_address, :shelter_tel
    include Dry.Types
    attribute :animal_id, Strict::Integer
    attribute :animal_kind, Strict::String
    attribute :animal_variate, Strict::String
    attribute :animal_sex, Strict::String
    attribute :animal_sterilization, Strict::Bool
    attribute :animal_bacterin, Strict::Bool
    attribute :animal_bodytype, Strict::String
    attribute :album_file, Strict::String
    # attribute :animal_place, Strict::String
    # attribute :animal_opendate, Strict::String
  end

  class Cat < Animal
  end

  class Dog < Animal
  end
end
