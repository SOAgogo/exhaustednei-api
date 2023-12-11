# frozen_string_literal: true

module PetAdoption
  module Accounts
    # class Info::ShelterMapper`
    class SitterMapper
      def self.find
        DataMapper.build_sitter_entity
      end
    end

    # Datamapper for adopter_info
    class DataMapper
      def self.build_sitter_entity
        PetAdoption::Entity::Sitters.new
      end
    end
  end
end
