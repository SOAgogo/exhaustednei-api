require 'uri'
require 'net/http'
require 'pry'
require 'json'
require 'yaml'
# verify your identification

module Info
  class ShelterList
    attr_accessor :shelter_hash

    def initialize
      @shelter_hash = {}
    end

    def howmanyshelters
      @shelter_hash.size
    end
  end

  class Shelter
    attr_reader :animal_id, :animal_area_pkid, :animal_shelter_pkid,
                :shelter_name, :shelter_address, :shelter_tel
    attr_accessor :animal_object_hash

    def initialize(data)
      @animal_object_hash = {}
      @animal_id = data['animal_id']
      @animal_area_pkid = data['animal_area_pkid']
      @animal_shelter_pkid = data['animal_shelter_pkid']
      @shelter_name = data['shelter_name']
      @shelter_address = data['shelter_address']
      @shelter_tel = data['shelter_tel']
    end

    def animal_nums
      @animal_object_hash.size
    end
  end

  def get_how_many_number_animals_in_shelter(animal_area_pkid)
    ShelterList.shelter_hash[animal_area_pkid].animal_nums
  end
end
