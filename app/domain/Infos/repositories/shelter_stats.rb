# frozen_string_literal: true

require_relative '../../shelter_animals/repositories/animals'
module Repository
  # Maps over local and remote git repo infrastructure
  module ShelterInfo
    # Repository for UserOrm
    class ShelterStats
      def self.animal_for_sterilization(shelter_name)
        animal_sterilizations = Database::ProjectOrm::AnimalOrm.find_all_animals_with_sterilization_by_shelter(shelter_name)
        Repository::Info::Animals.rebuild_many(animal_sterilizations)
        # ShelterStats.recorded_to_shelter_info('animal_sterilization',
        #                                       animal_sterilizations_db)
      end

      def self.animal_for_no_sterilization(shelter_name)
        animal_no_sterilizations = Database::ProjectOrm::AnimalOrm.find_all_animals_with_no_sterilization_by_shelter(shelter_name)
        Repository::Info::Animals.rebuild_many(animal_no_sterilizations)
        # ShelterStats.recorded_to_shelter_info('animal_no_sterilization',
        #                                       animal_no_sterilizations_db)
      end

      def self.shelter_intro(shelter_name)
        animal_sterilizations = ShelterStats.animal_for_sterilization(shelter_name)
        animal_no_sterilizations = ShelterStats.animal_for_no_sterilization(shelter_name)
        [animal_no_sterilizations, animal_sterilizations]
      end
    end
  end
end
