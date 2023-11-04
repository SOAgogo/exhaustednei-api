# frozen_string_literal: true

require 'sequel'

module Info
  module Database
    # Object-Relational Mapper for Animals
    class AnimalOrm < Sequel::Model(:animal)
      many_to_one :shelter_relations,
                  class: :'Info::Database::ShelterOrm'

      plugin :timestamps, update_on_create: true

      def self.find_or_create(member_info)
        first(username: member_info[:username]) || create(member_info)
      end
    end
  end
end
