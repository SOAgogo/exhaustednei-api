# frozen_string_literal: true

require 'dry-types'
require 'dry-struct'

# verify your identification

# --- TODO: delete the shelterList below ---
# class Info::ShelterList`
module MyModule
  include Dry.Types
  animal_area_pkid = Strict::Integer
  animal_shelter_pkid = Strict::Integer
  shelter_name = Strict::String
  shelter_address = Strict::String
  shelter_tel = Strict::String
  cat_number = Strict::Integer
  dog_number = Strict::Integer
  animal_object_list = Strict::Hash
end

module Entity
  # class Info::Shelter`
  class Shelter < Dry::Struct
    # class Shelter
    attr_reader :animal_object_list, :cat_number, :dog_number

    include Dry.Types

    attribute :animal_area_pkid, Strict::Integer
    attribute :animal_shelter_pkid, Strict::Integer
    attribute :shelter_name, Strict::String
    attribute :shelter_address, Strict::String
    attribute :shelter_tel, Strict::String
    attribute :cat_number, Strict::Integer
    attribute :dog_number, Strict::Integer
    attribute :animal_object_list, Strict::Hash

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
