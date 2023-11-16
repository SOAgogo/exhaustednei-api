# frozen_string_literal: true

require 'sequel'

module Database
  module ProjectOrm
    # Object-Relational Mapper for Animals
    class AnimalOrm < Sequel::Model(:animals)
      many_to_one :shelter_relations,
                  class: :'Database::ProjectOrm::ShelterOrm'
      many_to_one :user_relations,
                  class: :'Database::ProjectOrm::UserOrm'

      plugin :timestamps, update_on_create: true

      def self.find_or_create(animal_info)
        first(animal_id: animal_info[:animal_id]) || create(animal_info)
      end
    end
  end
end
