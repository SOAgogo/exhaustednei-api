# frozen_string_literal: true

require 'uri'
require 'net/http'
require 'pry'
require 'json'
require 'yaml'
# verify your identification

# --- TODO: delete the shelterList below ---
module Info
  # class Info::ShelterList`

  # class Info::Shelter`
  class Shelter
    # attr_reader :animal_id, :animal_area_pkid, :animal_shelter_pkid, :shelter_name, :shelter_address, :shelter_tel

    attr_accessor :animal_object_hash, :cat_number, :dog_number

    def initialize
      @animal_object_hash = {}
      @cat_number = 0
      @dog_number = 0
    end

    def animal_nums
      @animal_object_hash.size
    end
  end
end
