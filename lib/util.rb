# frozen_string_literal: true

# require_relative 'shelter'
# require_relative 'animal'
# util handle the parser and other methods
module Util
  # class Info::ShelterList`
  class Util
    def self.animal_parser(data)
      animal_data_hash = {}
      data.each do |key, value|
        animal_data_hash[key] = value unless %w[animal_area_pkid shelter_name shelter_address
                                                shelter_tel].include?(key)
      end
      animal_data_hash
    end

    def self.shelter_parser(data)
      shelter_data_hash = {}
      data.each do |key, value|
        shelter_data_hash[key] = value if %w[animal_area_pkid animal_shelter_pkid shelter_name shelter_address
                                             shelter_tel].include?(key)
      end
      shelter_data_hash
    end
  end
end
