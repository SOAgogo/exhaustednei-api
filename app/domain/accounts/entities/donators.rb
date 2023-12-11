# frozen_string_literal: true

# require 'dry-types'
# require 'dry-struct'
require_relative '../../shelter_animals/entities/shelters'
module PetAdoption
  module Entity
    # class Donators`
    class Donators
      # attribute :shelters, Strict::Array.of(Shelter)
      # each element in donate_money is the one gave to the shelter(one-one)
      def initialize
        @donate_shelters = {}
      end

      def premium_donators?
        total_donation = @donate_shelters.map { |_, money| money }.sum
        return 'GoldDonator' if total_donation >= 2000
        return 'SilverDonator' if total_donation >= 1000

        'BronzeDonator' if total_donation >= 500
      end

      def donate_money(shelter_name, amount)
        target_shelter = shelters.find { |s| s.name == shelter_name }
        target_shelter.money += amount
      end

      def premium_donator_account?
        'image recognition' if premium_donators == 'GoldDonator'
        'text recommendation' if premium_donators == 'SilverDonator'
      end
    end
  end
end
