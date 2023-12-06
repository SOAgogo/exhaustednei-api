# frozen_string_literal: true

require_relative '../../shelter_animals/repositories/animals'
module Repository
  # Maps over local and remote git repo infrastructure
  module Accounts
    # Repository for UserOrm
    class Users
      def initialize(user_info)
        @user_info = user_info
      end

      def create_user
        user_db = Database::ProjectOrm::UserOrm.find_or_create(@user_info)
        Users.rebuild_entity(user_db)
      end

      def self.rebuild_entity(user_db)
        return nil unless user_db

        PetAdoption::Entity::Accounts.new(
          session_id: user_db.session_id,
          firstname: user_db.firstname,
          lastname: user_db.lastname,
          phone: user_db.phone,
          email: user_db.email,
          address: user_db.address,
          donate_money: user_db.donate_money
        )
      end

      def self.find_by_session_id(session_id)
        rebuild_entity(Database::ProjectOrm::UserOrm.first(session_id:))
      end

      def self.find_row_id(session_id)
        Database::ProjectOrm::UserOrm.first(session_id:).id
      end

      def self.add_animal_foreign_key_by_session_id(session_id, animal_id)
        row_id = Database::ProjectOrm::UserOrm.first(session_id:).id
        animal_db = Repository::Info::Animals.find_animal_db_obj_by_id(animal_id)
        animal_db.update(users_id: row_id)
      end

      def self.rebuild_many(db_project)
        db_project.map do |db_user|
          Users.rebuild_entity(db_user)
        end
      end

      def self.get_animal_favorite_list_by_user(session_id, animal_id)
        Users.add_animal_foreign_key_by_session_id(session_id, animal_id)
        db_user_id = Database::ProjectOrm::UserOrm.first(session_id:).id
        db_project = Database::ProjectOrm::AnimalOrm
          .where(users_id: db_user_id)
          .all
        Repository::Info::Animals.rebuild_many(db_project)
      end
    end
  end
end
