# frozen_string_literal: true

require_relative 'adopter_mapper'
require_relative 'keeper_mapper'
require_relative 'donator_mapper'
require_relative 'sitter_mapper'

module PetAdoption
  module LossingPets
    # class Info::ShelterMapper`
    class AccountMapper
      attr_reader :account_info

      def initialize(account_info)
        @account_info = account_info
      end

      def find
        DataMapper.new(@account_info).build_account_info_entity
      end
    end

    # Datamapper for adopter_info
    class DataMapper
      def initialize(account_info)
        @data = account_info
      end

      def build_account_entity
        PetAdoption::Entity::LossingPets.new(
          PetAdoption::LossingPets::AdopterMapper.find,
          PetAdoption::LossingPets::DonatorMapper.find,
          PetAdoption::LossingPets::KeeperMapper.find,
          PetAdoption::LossingPets::SitterMapper.find,
          { firstname:,
            lastname:,
            phone:,
            email:,
            address:,
            donate_money: }
        )
      end

      private

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
