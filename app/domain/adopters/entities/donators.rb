# frozen_string_literal: true

require_relative 'account'
require_relative '../../shelter_animals/entities/shelter'
module PetAdoption
  module Entity
    # class Donators`
    class Donators < Account
      attribute :id, Integer.optional
      attribute :donater_id, Strict::Integer
      attribute :shelters, Strict::Array.of(Shelter)
      # each element in donate_money is the one gave to the shelter(one-one)
      attribute :donate_money, Strict::Array.of(Integer)
      attribute :created_at, Strict::String
      attribute :updated_at, Strict::String

      def pay_money_to_shelter(shelter_pkid, amount)
        shelter = shelters.find { |shelter| shelter.id == shelter_pkid }
        shelter.money += amount
      end
    end
  end
end
