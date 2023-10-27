# frozen_string_literal: true

module Info
  # class Info::ShelterMapper`
  class ShelterMapper
    attr_reader :shelter_hash

    @temporary_shelter_hash = {}
    def initialize
      @shelter_hash = ShelterList.temporary_shelter_hash
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
end
