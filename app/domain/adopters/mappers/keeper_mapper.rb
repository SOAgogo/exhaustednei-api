# frozen_string_literal: true

require 'pry'
module PetAdoption
  module Adopters
    # class Info::ShelterMapper`
    class KeeperMapper
      attr_reader :keeper_info

      def initialize(keeper_info)
        @keeper_info = keeper_info
      end

      def find
        DataMapper.new(@keeper_info).build_keeper_entity
      end
    end

    # Datamapper for donator
    class DataMapper
      def initialize(keeper_info)
        @data = keeper_info
      end

      def build_keeper_entity
        PetAdoption::Entity::Keepers.new(
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
