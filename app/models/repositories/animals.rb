# frozen_string_literal: true

module Repository
  module Info
    # Repository for Members
    class Animals
      def self.find_all_animal_by_id(_animal_id)
        Database::ProjectOrm::AnimalOrm.all.map { |db_project| rebuild_entity(db_project) }
      end

      def self.find_id(id)
        rebuild_entity(Database::ProjectOrm::AnimalOrm.first(id:))
      end

      def self.find_username(username)
        rebuild_entity(Database::ProjectOrm::AnimalOrm.first(username:))
      end

      def self.rebuild_entity(db_record)
        return nil unless db_record

        Entity::Animal.new(
          id: db_record.id,
          animal_id: db_record.animal_id,
          animal_kind: db_record.animal_kind,
          animal_variate: db_record.animal_variate,
          animal_sex: db_record.animal_sex,
          animal_sterilization: db_record.animal_sterilization,
          animal_bacterin: db_record.animal_bacterin,
          animal_bodytype: db_record.animal_bodytype,
          album_file: db_record.album_file,
          animal_place: db_record.animal_place,
          animal_opendate: db_record.animal_opendate
        )
      end

      def self.find(entity)
        find_animal_id(entity.animal_id)
      end

      def self.find_animal_id(animal_id)
        db_record = Database::ProjectOrm::AnimalOrm.first(animal_id:)
        rebuild_entity(db_record)
      end

      def self.create(entity)
        raise 'Project already exists' if find(entity)

        db_project = PersistProject.new(entity).call
        rebuild_entity(db_project)
      end

      def self.find_full_animals_in_shelter(shelter_name)
        Database::ProjectOrm::AnimalOrm
          # .right_join(:shelters, id: :shelter_id)
          .where(animal_place: shelter_name)
          .all
      end

      def self.rebuild_many(db_records)
        db_records.map do |db_member|
          Members.rebuild_entity(db_member)
        end
      end

      def self.store_several(animal_obj_list)
        animal_obj_list.map do |_, animal_obj|
          db_find_or_create(animal_obj)
        end
      end

      #
      # create an entry for each contributor
      def self.db_find_or_create(entity)
        # #<CodePraise::Entity::Member id=nil origin_id=1926704 username="soumyaray" email=nil>
        # to hash {:origin_id=>1926704, :username=>"soumyaray", :email=>nil}
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

        # def call
        #   # if owner is not in database, create one, otherwise, return it
        #   # animal_info = Shelters.db_find_or_create(@entity.animal_place)

        #   # update owner and contributors field
        #   # create_project: 沒有產生owner_id
        #   create_project.tap do |db_project|
        #     db_project.update(shelter_relations:) # 在這邊更新shelter_id !!!!

        #     @entity.contributors.each do |contributor|
        #       # add_contributor relates to many_to_many relationship in project_orm.rb
        #       db_project.add_contributor(Members.db_find_or_create(contributor))
        #     end
        #   end
        # end
      end
    end
  end
end
