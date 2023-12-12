# frozen_string_literal: true

require 'sequel'

module Database
  module ProjectOrm
    # Object-Relational Mapper for Animals
    class LossingPetsOrm < Sequel::Model(:loss_animals)
      plugin :timestamps, update_on_create: true

      def self.find_or_create(user_info)
        first(county: user_info[:county]) || create(user_info)
      end

      def self.find_all_lost_animals_in_county(county)
        where(county:).all
      end
    end
  end
end
