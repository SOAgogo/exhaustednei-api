# frozen_string_literal: true

module PetAdoption
  module Accounts
    # class Info::ShelterMapper`
    class AccountMapper
      attr_reader :adopter_info

      def initialize(adopter_info)
        @adopter_info = adopter_info
      end

      def find
        DataMapper.new(@adopter_info).build_account_info_entity
      end
    end

    # Datamapper for adopter_info
    class DataMapper
      def initialize(adopter_info_info)
        @data = adopter_info_info
      end

      def build_account_info_entity
        PetAdoption::Entity::Accounts.new(
          session_id:,
          firstname:,
          lastname:,
          phone:,
          email:,
          address:,
          donate_money:
        )
      end

      private

      def session_id
        @data['session_id']
      end

      def firstname
        @data['firstname']
      end

      def lastname
        @data['lastname']
      end

      def phone
        @data['phone']
      end

      def email
        @data['email']
      end

      def address
        @data['address']
      end

      def donate_money
        0
      end
    end
  end
end
