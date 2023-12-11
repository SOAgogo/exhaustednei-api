# frozen_string_literal: true

require 'pry'
module PetAdoption
  module Accounts
    # class Info::ShelterMapper`
    class KeeperMapper
      def self.find
        DataMapper.build_keeper_entity
      end
    end

    # Datamapper for donator
    class DataMapper
      def build_keeper_entity
        PetAdoption::Entity::Keepers.new
      end
    end
  end
end
