# frozen_string_literal: true

module Repository
  module Info
    # Repository for Members
    class Animals
      def self.find_all_animal
        Database::ProjectOrm::AnimalOrm.all.map { |db_project| rebuild_entity(db_project) }
      end

      def self.find_animal_by_id(origin_id)
        rebuild_entity(Database::ProjectOrm::AnimalOrm.first(origin_id:))
      end

      def self.find_animal_db_obj_by_id(origin_id)
        Database::ProjectOrm::AnimalOrm.first(origin_id:)
      end

      def self.web_page_cover
        first_record = Database::ProjectOrm::AnimalOrm
          .exclude(album_file: '')
          .first
        album_file = first_record.album_file
        if album_file == ''
          DBError.new('DB error', 'DB cant find your data').tap do |rsp|
            raise(rsp.error)
          end
        end
        album_file
      end

      # rubocop:disable Metrics/MethodLength
      def self.rebuild_entity(db_record)
        return nil unless db_record

        PetAdoption::Entity::Animal.new(
          id: db_record.id,
          remote_id: db_record.remote_id,
          species: db_record.species,
          age: db_record.age,
          color: db_record.color,
          sex: db_record.sex,
          sterilized: db_record.sterilized,
          vaccinated: db_record.vaccinated,
          body_type: db_record.body_type,
          image_url: db_record.image_url,
          registration_date: db_record.registration_date
        )
      end

      # rubocop:enable Metrics/MethodLength
      def self.select_animal_by_shelter_name(animal_kind, shelter_name)
        db_record = Database::ProjectOrm::AnimalOrm.where(animal_kind:, animal_place: shelter_name).all
        if db_record.empty?
          DBError.new('DB error', 'DB cant find your data').tap do |rsp|
            raise(rsp.error)
          end
        end
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
          animal_obj_list[db_member.origin_id] = Animals.rebuild_entity(db_member)
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
