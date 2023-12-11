# frozen_string_literal: true

require 'pry'
module PetAdoption
  module Accounts
    # class Info::ShelterMapper`
    class DonatorMapper
      def self.find
        DataMapper.build_donator_entity
      end
    end

    # Datamapper for donator
    class DataMapper
      def build_donator_entity
        PetAdoption::Entity::Donators.new
      end
    end
  end
end
