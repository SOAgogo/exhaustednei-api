# frozen_string_literal: true

# require 'dry-types'
# require 'dry-struct'
require_relative '../../shelter_animals/entities/shelter'
module PetAdoption
  module Entity
    # class Donators`
    class Donators
      # attribute :shelters, Strict::Array.of(Shelter)
      # each element in donate_money is the one gave to the shelter(one-one)
      def initialize(accounts = PetAdoption::Entity::Accounts.new)
        @accounts = accounts
        @shelters = {}
      end

      def to_attr_hash
        to_hash.except(:address)
      end

      # def pay_money_to_shelter(shelter_pkid, amount)
      #   shelter = shelters.find { |shelter| shelter.id == shelter_pkid }
      #   shelter.money += amount
      # end
    end
  end
end
