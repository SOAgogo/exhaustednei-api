# frozen_string_literal: true

require 'pry'
module Repository
  # Maps over local and remote git repo infrastructure
  module Adopters
    # Repository for UserOrm
    class Users
      def initialize(user_info)
        @user_info = user_info
      end

      def create_user
        Database::ProjectOrm::UserOrm.find_or_create(@user_info)
      end

      def rebuild_entity
        return nil unless @user_info

        PetAdoption::Entity::User.new(
          session_id: @user_info.session_id,
          firstname: @user_info.firstname,
          lastname: @user_info.lastname,
          phone: @user_info.phone,
          email: @user_info.email,
          address: @user_info.address,
          donate_money: @user_info.donate_money
        )
      end
    end
  end
end
