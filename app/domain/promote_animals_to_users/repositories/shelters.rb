# frozen_string_literal: true

require_relative 'animals'

module PetAdoption
  module Repository
    # Repository for Project Entities
    class Shelters
      def self.find_all_shelters_by_county(county)
        shelters_in_county = Database::ProjectOrm::ShelterOrm.find_shelters_county(county)
        shelters_in_county.map(&:name)
      end

      def self.all_shelter_names
        Database::ProjectOrm::ShelterOrm.all.map(&:name)
      end

      def self.find_shelter_by_name(name)
        # still can't get the data from database
        db_record = Database::ProjectOrm::ShelterOrm.find_name(name)
        rebuild_entity(db_record)
      end

      def self.rebuild_entity(db_record)
        return nil unless db_record

        db_animals = Animals.find_full_animals_in_shelter(db_record.name)

        selected_keys = %i[origin_id name address phone_number]
        # broken here
        PetAdoption::Entity::Shelter.new(
          # db_record.to_hash.merge(
          #   animal_object_list: Animals.rebuild_many(db_animals)
          # )
          db_record.to_hash.slice(*selected_keys),
          Animals.rebuild_many(db_animals)
        )
      end

      def self.db_find_or_create(entity)
        shelter_db_obj = Database::ProjectOrm::ShelterOrm.find_or_create(entity.to_attr_hash)
        PersistShelter.new(entity).call
        shelter_db_obj
      end

      # Helper class to persist project and its members to database
      class PersistShelter
        def initialize(entity)
          @entity = entity
        end

        def create_shelter
          # Database::ProjectOrm::ShelterOrm.create(@entity.to_attr_hash)
          Database::ProjectOrm::ShelterOrm.find_or_create(@entity.to_attr_hash)
        end

        def self.add_foeign_key_to_animal(animal_database_list, shelter)
          animal_database_list.map do |animal_database|
            animal_database.tap do |db_animal|
              db_animal.shelter_id = shelter.id
              db_animal.save
            end
          end
        end

        def call
          animal_database_list = Animals.store_several(@entity.shelter_stats.animal_obj_list)

          shelter = create_shelter
          PersistShelter.add_foeign_key_to_animal(animal_database_list, shelter)
          shelter
        end
      end
    end
  end
end
