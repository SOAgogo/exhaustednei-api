# frozen_string_literal: true

require 'uri'
require 'net/http'
require 'pry'
require 'json'
require 'yaml'
# verify your identification

module Info
  # class Info::ShelterList`
  class ShelterList
    attr_accessor :shelter_hash

    def initialize
      @shelter_hash = {}
    end

    def howmanyshelters
      @shelter_hash.size
    end

    def calculate_dog_nums
      # obj is a shelter object
      sum = 0
      @shelter_hash.each do |_, obj|
        sum += obj.dog_number
      end
      sum
    end

    def calculate_cat_nums
      # obj is a shelter object
      sum = 0
      @shelter_hash.each do |_, obj|
        sum += obj.cat_number
      end
      sum
    end

    def get_the_shelter(animal_area_pkid)
      @shelter_hash[animal_area_pkid]
    end
  end

  # class Info::Shelter`
  class Shelter
    attr_reader :animal_id, :animal_area_pkid, :animal_shelter_pkid, :shelter_name, :shelter_address, :shelter_tel,
                :dog_number, :animal_object_hash

    attr_accessor :animal_object_hash, :cat_number, :dog_number

    def initialize(data)
      @animal_object_hash = {}
      @animal_id = data['animal_id']
      @animal_area_pkid = data['animal_area_pkid']
      @animal_shelter_pkid = data['animal_shelter_pkid']
      @shelter_name = data['shelter_name']
      @shelter_address = data['shelter_address']
      @shelter_tel = data['shelter_tel']
      @cat_number = 0
      @dog_number = 0
    end

    def animal_nums
      @animal_object_hash.size
    end
  end
end
