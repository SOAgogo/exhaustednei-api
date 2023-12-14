# frozen_string_literal: true

require 'sequel'
require 'pry'

module Database
  module ProjectOrm
    # Object-Relational Mapper for Animals
    class AnimalOrm < Sequel::Model(:animals)
      many_to_one :shelter_relations,
                  class: :'Database::ProjectOrm::ShelterOrm'

      plugin :timestamps, update_on_create: true

      def self.find_or_create(animal_info)
        binding.pry
        first(origin_id: animal_info[:origin_id]) || create(animal_info)
      end

      # for combination queries

      def self.handle_with_custom_query(query)
        # query is a hash with symbol
        where(query).all
      end
    end
  end
end
