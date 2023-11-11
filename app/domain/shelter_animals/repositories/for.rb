# frozen_string_literal: true

require_relative 'animals'
require_relative 'shelters'

module Repository
  module Info
    # Finds the right repository for an entity object or class
    module For
      ENTITY_REPOSITORY = {
        PetAdoption::Entity::Dog => Animals,
        PetAdoption::Entity::Cat => Animals,
        PetAdoption::Entity::Shelter => Shelters
      }.freeze

      def self.klass(entity_klass)
        ENTITY_REPOSITORY[entity_klass]
      end

      def self.entity(entity_object)
        ENTITY_REPOSITORY[entity_object.class]
      end
    end
  end
end
