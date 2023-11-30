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
          animal_no_sterilizations: @shelter_info['no_sterilization'],
          animal_sterilizations: @shelter_info['sterilization'],
          animal_for_bacterin: @shelter_info['animal_bacterin'],
          animal_for_no_bacterin: @shelter_info['no_animal_bacterin']
        )
      end
    end
  end
end
