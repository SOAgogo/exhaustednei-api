# frozen_string_literal: true

require 'dry-types'
require 'dry-struct'

# class Info::ShelterList`

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
  end
end
