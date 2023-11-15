# frozen_string_literal: true

module Repository
  module Info
    # Repository for Members
    class Animals
      def self.find_all_animal
        Database::ProjectOrm::AnimalOrm.all.map { |db_project| rebuild_entity(db_project) }
      end

      def self.find_animal_by_id(animal_id)
        rebuild_entity(Database::ProjectOrm::AnimalOrm.first(animal_id:))
      end

      def self.web_page_cover
        Database::ProjectOrm::AnimalOrm
          # .right_join(:shelters, id: :shelter_id)
          .where(:animal_file != '')
          .first.album_file
      end

      # rubocop:disable Metrics/MethodLength
      def self.rebuild_entity(db_record)
        return nil unless db_record

        PetAdoption::Entity::Animal.new(
          id: db_record.id,
          animal_id: db_record.animal_id,
          animal_kind: db_record.animal_kind,
          animal_variate: db_record.animal_variate,
          animal_found_place: db_record.animal_found_place,
          animal_age: db_record.animal_age,
          animal_color: db_record.animal_color,
          animal_sex: db_record.animal_sex,
          animal_sterilization: db_record.animal_sterilization,
          animal_bacterin: db_record.animal_bacterin,
          animal_bodytype: db_record.animal_bodytype,
          album_file: db_record.album_file,
          animal_place: db_record.animal_place,
          animal_opendate: db_record.animal_opendate
        )
      end

      # rubocop:enable Metrics/MethodLength
      def self.select_animal_by_shelter_name(animal_kind, shelter_name)
        db_record = Database::ProjectOrm::AnimalOrm.where(animal_kind:, animal_place: shelter_name).all
        rebuild_many(db_record)
      end

      def self.create(entity)
        raise 'Project already exists' if find(entity)

        db_project = PersistProject.new(entity).call
        rebuild_entity(db_project)
      end

      def self.find_full_animals_in_shelter(shelter_name)
        Database::ProjectOrm::AnimalOrm
          .where(animal_place: shelter_name)
          .all
      end

      def self.rebuild_many(db_records)
        animal_obj_list = {}
        db_records.map do |db_member|
          animal_obj_list[db_member.animal_id] = Animals.rebuild_entity(db_member)
        end
        animal_obj_list
      end

      def self.store_several(animal_obj_list)
        animal_obj_list.map do |_, animal_obj|
          db_find_or_create(animal_obj)
        end
      end

      #
      # create an entry for each contributor
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
    end
  end
end
