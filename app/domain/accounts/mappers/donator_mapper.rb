# frozen_string_literal: true

require 'pry'
module PetAdoption
  module Accounts
    # class Info::ShelterMapper`
    class DonatorMapper
      attr_reader :donator_info

      def initialize(donator_info)
        @donator_info = donator_info
      end

      def find
        DataMapper.new(@donator_info).build_donator_entity
      end
    end

    # Datamapper for donator
    class DataMapper
      def initialize(donator_info)
        @data = donator_info
      end

      def build_donator_entity
        PetAdoption::Entity::Donators.new(
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
