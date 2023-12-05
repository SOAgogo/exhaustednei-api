# frozen_string_literal: true

require_relative '../../shelter_animals/repositories/animals'
require_relative 'shelter_info_mapper'
module PetAdoption
  # Maps over local and remote git repo infrastructure
  module ShelterInfo
    # County shelter mapper
    class CountyShelterMapper
      def initialize(county_name)
        # which shelters are in this county
        @county_shelters = Repository::ShelterInfo::CountyShelterStats.county_intro(county_name)
      end

      def build_entity
        county_info = {}
        @county_shelters.each do |shelter_name|
          county_info[shelter_name] = ShelterInfoMapper.new(shelter_name).build_entity
        end
        Entity::CountyShelterStats.new(county_info)
      end
    end
  end
end
