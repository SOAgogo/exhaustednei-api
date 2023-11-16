# frozen_string_literal: true

module Repository
  # Maps over local and remote git repo infrastructure
  module Adopters
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
    end
  end
end
