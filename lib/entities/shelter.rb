# frozen_string_literal: true

require 'dry-types'
require 'dry-struct'

# class Info::ShelterList`

module Entity
  # class Info::Shelter`
  class Shelter < Dry::Struct
    include Dry.Types

    attribute :animal_area_pkid, Strict::Integer
    attribute :animal_shelter_pkid, Strict::Integer
    attribute :shelter_name, Strict::String
    attribute :shelter_address, Strict::String
    attribute :shelter_tel, Strict::String
    # add animal object list to shelter
    atrribute :animal_object_list, Strict::Hash.map(Types::Strict::Integer, Animal)
    attribute :cat_number, Strict::Integer
    attribute :dog_number, Strict::Integer
    attribute :animal_number, Strict::Integer
  end
end
