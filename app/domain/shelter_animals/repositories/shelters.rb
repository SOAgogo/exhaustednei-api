# frozen_string_literal: true

require_relative 'animals'
require 'pry'

module Repository
  module Info
    # Repository for Project Entities
    class Shelters
      def self.all
        Database::ShelterOrm.all.map { |db_project| rebuild_entity(db_project) }
      end

      def self.find(entity)
        find_shelter_id(entity.animal_shelter_pkid)
      end

      def self.find_shelter_by_name(shelter_name)
        db_record = Database::ProjectOrm::ShelterOrm.where(shelter_name:).first
        rebuild_entity(db_record)
      end

      def self.find_shelter_id(animal_shelter_pkid)
        db_record = Database::ProjectOrm::ShelterOrm.first(animal_shelter_pkid:)
        rebuild_entity(db_record)
      end

      def self.create(entity)
        raise 'Shelter already exists' if find(entity)

        # return shelter obj
        db_project = PersistShelter.new(entity).call

        rebuild_entity(db_project)
      end

      def self.rebuild_entity(db_record)
        return nil unless db_record

        db_animals = Animals.find_full_animals_in_shelter(db_record.shelter_name)

        Entity::Shelter.new(
          db_record.to_hash.merge(
            animal_object_list: Animals.rebuild_many(db_animals)
          )
        )
      end

      def self.db_find_or_create(entity)
        Database::ProjectOrm::ShelterOrm.find_or_create(entity.to_attr_hash)
      end

      # Helper class to persist project and its members to database
      class PersistShelter
        def initialize(entity)
          @entity = entity
        end

        def create_shelter
          Database::ProjectOrm::ShelterOrm.create(@entity.to_attr_hash)
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
          # if owner is not in database, create one, otherwise, return it
          animal_database_list = Animals.store_several(@entity.animal_object_list)

          shelter = create_shelter
          PersistShelter.add_foeign_key_to_animal(animal_database_list, shelter)
          shelter
        end
      end
    end
  end
end
