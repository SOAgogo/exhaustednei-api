# frozen_string_literal: true

require 'sequel'

module Database
  module ProjectOrm
    # Object-Relational Mapper for Shelters
    class ShelterOrm < Sequel::Model(:shelters)
      one_to_many :animal_relations,
                  class: :'Database::ProjectOrm::AnimalOrm',
                  key: :shelter_id

      plugin :timestamps, update_on_create: true

      def self.find_or_create(shelter_info)
        first(origin_id: shelter_info[:origin_id]) || create(shelter_info)
      end

      def self.find_name(name)
        first(name:)
      end

      def self.find_id(origin_id)
        first(origin_id:)
      end

      def self.find_shelters_county(county)
        where(Sequel.like(:name, "#{county}%")).all
      end
    end
  end
end
