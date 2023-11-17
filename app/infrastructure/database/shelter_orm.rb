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
        first(animal_shelter_pkid: shelter_info[:animal_shelter_pkid]) || create(shelter_info)
      end
    end
  end
end
