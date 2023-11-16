# frozen_string_literal: true

require 'sequel'
require 'pry'
module Database
  module ProjectOrm
    # Object-Relational Mapper for Animals
    class UserOrm < Sequel::Model(:users)
      one_to_many :animal_relations,
                  class: :'Database::ProjectOrm::AnimalOrm',
                  key: :user_id

      plugin :timestamps, update_on_create: true

      def self.find_or_create(user_info)
        first(session_id: user_info[:session_id]) || create(user_info)
      end
    end
  end
end
