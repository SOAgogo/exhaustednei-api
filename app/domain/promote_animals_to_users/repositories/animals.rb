# frozen_string_literal: true

require 'pry'
module PetAdoption
  module Repository
    # Repository for Members
    class Animals
      def self.error_message(db_record)
        return unless db_record.empty?

        DBError.new('DB error', 'DB cant find your data').tap do |rsp|
          raise(rsp.error)
        end
      end

      def self.find_animal(origin_id)
        Database::ProjectOrm::AnimalOrm.where(origin_id:).first
      end

      def self.web_page_cover
        first_record = Database::ProjectOrm::AnimalOrm
          .exclude(image_url: '')
          .first
        album_file = first_record.image_url
        if album_file == ''
          DBError.new('DB error', 'DB cant find your data').tap do |rsp|
            raise(rsp.error)
          end
        end
        album_file
      end

      def self.find_full_animals_in_shelter(shelter_name)
        Database::ProjectOrm::AnimalOrm.graph(:shelters, id: :shelter_id)
          .where(name: shelter_name).all
      end

      def self.find_all_animals_in_shelter(shelter_name)
        db_record = find_full_animals_in_shelter(shelter_name)
        error_message(db_record)
        rebuild_many(db_record)
      end

      # rubocop:disable Metrics/MethodLength,Lint/MissingCopEnableDirective
      def self.rebuild_entity(db_record) # rubocop:disable Metrics/AbcSize
        return nil unless db_record

        if db_record.kind == '狗'
          PetAdoption::Entity::Dog.new(
            origin_id: db_record.origin_id,
            kind: db_record.kind,
            species: db_record.species,
            age: db_record.age,
            color: db_record.color,
            sex: db_record.sex,
            sterilized: db_record.sterilized,
            vaccinated: db_record.vaccinated,
            bodytype: db_record.bodytype,
            image_url: db_record.image_url,
            registration_date: db_record.registration_date
          )
        else
          PetAdoption::Entity::Cat.new(
            origin_id: db_record.origin_id,
            kind: db_record.kind,
            species: db_record.species,
            age: db_record.age,
            color: db_record.color,
            sex: db_record.sex,
            sterilized: db_record.sterilized,
            vaccinated: db_record.vaccinated,
            bodytype: db_record.bodytype,
            image_url: db_record.image_url,
            registration_date: db_record.registration_date
          )
        end
      end

      def self.select_animal_by_shelter_name_kind(animal_kind, shelter_name)
        db_record = Database::ProjectOrm::AnimalOrm.graph(:shelters, id: :shelter_id)
          .where(kind: animal_kind, name: shelter_name).all

        error_message(db_record)
        rebuild_many(db_record)
      end

      def self.select_animals_by_shelter(shelter_name)
        db_record = find_full_animals_in_shelter(shelter_name)
        error_message(db_record)
        rebuild_many_without_id(shelter_name, db_record)
      end

      def self.create(entity)
        raise 'Project already exists' if find(entity)

        db_project = PersistProject.new(entity).call
        rebuild_entity(db_project)
      end

      def self.rebuild_many(db_records)
        animal_obj_list = {}
        db_records.map do |db_member|
          animal_obj_list[db_member.origin_id] = Animals.rebuild_entity(db_member)
        end
        animal_obj_list
      end

      def self.rebuild_many_without_id(shelter_name, db_records)
        db_records.map do |db_member|
          [shelter_name, Animals.rebuild_entity(db_member)]
        end
      end

      def self.store_several(animal_obj_list)
        animal_obj_list.map do |_, animal_obj|
          db_find_or_create(animal_obj)
        end
      end

      def self.db_find_or_create(entity)
        Database::ProjectOrm::AnimalOrm.find_or_create(entity.to_attr_hash)
      end

      # Helper class to persist project and its members to database
      class PersistProject
        def initialize(entity)
          @entity = entity
        end

        def create_project
          Database::ProjectOrm::AnimalOrm.create(@entity.to_attr_hash)
        end
      end

      # DBError for custom error messages
      class DBError < StandardError
        attr_reader :thing

        def initialize(msg = 'DB error', thing = 'DB cant find your data')
          @thing = thing
          super(msg)
        end
      end
    end
  end
end
