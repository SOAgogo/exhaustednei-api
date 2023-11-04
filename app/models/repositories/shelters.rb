# frozen_string_literal: true

require_relative 'animals'

module Repository
  module Info
    # Repository for Project Entities
    class Shelters
      def self.all
        Database::ProjectOrm.all.map { |db_project| rebuild_entity(db_project) }
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
        find_origin_id(entity.origin_id)
      end

      def self.find_id(id)
        db_record = Database::ProjectOrm.first(id:)
        rebuild_entity(db_record)
      end

      def self.find_origin_id(origin_id)
        db_record = Database::ProjectOrm.first(origin_id:)
        rebuild_entity(db_record)
      end

      def self.create(entity)
        raise 'Project already exists' if find(entity)

        db_project = PersistProject.new(entity).call
        rebuild_entity(db_project)
      end

      def self.rebuild_entity(db_record)
        return nil unless db_record

        # binding.pry
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
        Entity::Project.new(
          db_record.to_hash.merge(
            owner: Members.rebuild_entity(db_record.owner),
            contributors: Members.rebuild_many(db_record.contributors)
          )
        )
        # after the preious operation, Project object will add owner and contributors field
        # <CodePraise::Entity::Project id=1 origin_id=104999627 name="YPBT-app" size=551 ssh_url="git://github.com/soumyaray/YPBT-app.git" http_url="https://github.com/soumyaray/YPBT-app" owner=#<CodePraise::Entity::Member id=1 origin_id=1926704 username="soumyaray" email=nil> contributors=[#<CodePraise::Entity::Member id=2 origin_id=8809778 username="Yuan-Yu" email=nil>,
      end

      # Helper class to persist project and its members to database
      class PersistProject
        def initialize(entity)
          @entity = entity
        end

        def create_project
          Database::ProjectOrm.create(@entity.to_attr_hash)
        end

        def call
          # if owner is not in database, create one, otherwise, return it
          owner = Members.db_find_or_create(@entity.owner)

          # update owner and contributors field
          # create_project: 沒有產生owner_id
          create_project.tap do |db_project|
            db_project.update(owner:) # 在這邊更新owner_id !!!!

            @entity.contributors.each do |contributor|
              # add_contributor relates to many_to_many relationship in project_orm.rb
              db_project.add_contributor(Members.db_find_or_create(contributor))
            end
          end
        end
      end
    end
  end
end
