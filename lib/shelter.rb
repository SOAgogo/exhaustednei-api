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
  end

  class Shelter
    def initialize(data)
      
    end
  end

  def getHowManynumberInShelter(shelter_name)
    ShelterList.shelter_hash[shelter_name].getAnimalNums
  end
end
