# frozen_string_literal: true

require 'sequel'

module Database
  module ProjectOrm
    # Object-Relational Mapper for Animals
    class AnimalOrm < Sequel::Model(:animals)
      many_to_one :shelter_relations,
                  class: :'Info::Database::ShelterOrm'

      plugin :timestamps, update_on_create: true

      def self.find_or_create(animal_info)
        first(animal_id: animal_info[:animal_id]) || create(animal_info)
      end

      def self.find_or_create_many(animal_info)
        first(animal_variate: animal_info[:animal_variate]) || create(animal_info)
      end
    end
  end
end
