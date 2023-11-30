# frozen_string_literal: true

require_relative '../../shelter_animals/repositories/animals'
module Repository
  # Maps over local and remote git repo infrastructure
  module ShelterInfo
    # Repository for UserOrm
    class ShelterStats
      def self.outputs_from_orm_query(query)
        animal_db_obj = Database::ProjectOrm::AnimalOrm.handle_with_custom_query(query)
        Repository::Info::Animals.rebuild_many(animal_db_obj)
      end

      def self.animal_for_sterilization(shelter_name)
        query = { animal_sterilization: true, animal_place: shelter_name }
        outputs_from_orm_query(query)
      end

      def self.animal_for_no_sterilization(shelter_name)
        query = { animal_sterilization: false, animal_place: shelter_name }
        outputs_from_orm_query(query)
      end

      def self.animal_for_animal_bacterin(shelter_name)
        query = { animal_bacterin: true, animal_place: shelter_name }
        outputs_from_orm_query(query)
      end

      def self.animal_for_no_animal_bacterin(shelter_name)
        query = { animal_bacterin: false, animal_place: shelter_name }
        outputs_from_orm_query(query)
      end

      def self.shelter_intro(shelter_name)
        animal_sterilizations = ShelterStats.animal_for_sterilization(shelter_name)
        animal_no_sterilizations = ShelterStats.animal_for_no_sterilization(shelter_name)
        animal_for_animal_bacterin = ShelterStats.animal_for_animal_bacterin(shelter_name)
        animal_for_no_animal_bacterin = ShelterStats.animal_for_no_animal_bacterin(shelter_name)

        { 'sterilization' => animal_sterilizations,
          'no_sterilization' => animal_no_sterilizations,
          'animal_bacterin' => animal_for_animal_bacterin,
          'no_animal_bacterin' => animal_for_no_animal_bacterin }
      end
    end
  end
end
