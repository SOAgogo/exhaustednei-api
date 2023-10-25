# frozen_string_literal: true

# util handle the parser and other methods
module Util
  # class Info::ShelterList`
  class Util
    def self.parser(data)
      animal_data_hash = {}
      data.each do |key, value|
        animal_data_hash[key] = value unless %w[animal_area_pkid shelter_name shelter_address
                                                shelter_tel].include?(key)
      end
      animal_data_hash
    end
  end
end
