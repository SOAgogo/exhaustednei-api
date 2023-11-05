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

      def self.find_full_name(owner_name, project_name)
        # SELECT * FROM `projects` LEFT JOIN `members`
        # ON (`members`.`id` = `projects`.`owner_id`)
        # WHERE ((`username` = 'owner_name') AND (`name` = 'project_name'))
        db_project = Database::ProjectOrm
          .left_join(:members, id: :owner_id)
          .where(username: owner_name, name: project_name)
          .first
        rebuild_entity(db_project)
      end

      def self.find(entity)
        find_shelter_id(entity.animal_shelter_pkid)
      end

      def self.find_id(id)
        db_record = Database::ProjectOrm::ShelterOrm.first(id:)
        rebuild_entity(db_record)
      end

      def self.find_shelter_id(animal_shelter_pkid)
        db_record = Database::ProjectOrm::ShelterOrm.first(animal_shelter_pkid:)
        rebuild_entity(db_record)
      end

      def self.create(entity)
        raise 'Shelter already exists' if find(entity)


        # binding.pry
        db_project = PersistShelter.new(entity).call

        rebuild_entity(db_project)
      end

      def self.rebuild_entity(db_record)
        return nil unless db_record

        # db_record.to_hash like this:
        # {:id=>2,
        #   :owner_id=>5,
        #   :origin_id=>518708142,
        #   :name=>"kwok",
        #   :ssh_url=>"git://github.com/kubernetes-sigs/kwok.git",
        #   :http_url=>"https://github.com/kubernetes-sigs/kwok",
        #   :size=>3262,
        #   :created_at=>2023-11-03 12:47:06.393605 +0800,
        #   :updated_at=>2023-11-03 12:47:06.396262 +0800}

        db_animals = Animals.find_full_animals_in_shelter(db_record.shelter_name)


        Entity::Shelter.new(
          db_record.to_hash.merge(
            # change here !!
            animal_object_list: Animals.rebuild_many(db_animals)
          )
        )
        # after the preious operation, Project object will add owner and contributors field
        # <CodePraise::Entity::Project id=1 origin_id=104999627 name="YPBT-app" size=551 ssh_url="git://github.com/soumyaray/YPBT-app.git" http_url="https://github.com/soumyaray/YPBT-app" owner=#<CodePraise::Entity::Member id=1 origin_id=1926704 username="soumyaray" email=nil> contributors=[#<CodePraise::Entity::Member id=2 origin_id=8809778 username="Yuan-Yu" email=nil>,
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

        def call
          # if owner is not in database, create one, otherwise, return it
          animal_database_list = Animals.store_several(@entity.animal_object_list)

          shelter = create_shelter

          animal_database_list.map do |animal_database|
            animal_database.tap do |db_animal|
              # chaneg the foreign key

              db_animal.shelter_id = shelter.id
              db_animal.save
            end
          end
          
          shelter
        end
      end
    end
  end
end
