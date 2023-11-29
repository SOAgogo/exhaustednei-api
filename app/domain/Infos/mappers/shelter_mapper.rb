# frozen_string_literal: true

module PetAdoption
  # ShelterInfo
  module ShelterInfo
    # ShelterInfoMapper
    class ShelterInfoMapper
      def initialize(shelter_name)
        @shelter_info = Repository::ShelterInfo::ShelterStats.shelter_intro(shelter_name)
      end

      def build_entity
        Entity::ShelterStats.new(
          animal_no_sterilizations: @shelter_info[0],
          animal_sterilizations: @shelter_info[1]
        )
      end
    end
  end
end
