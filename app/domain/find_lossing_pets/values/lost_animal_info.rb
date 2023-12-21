# frozen_string_literal: true

# this is for calculating how much a member donate money to a shelter
module PetAdoption
  module Value
    # DonationCalculator
    class LostAnimalInfo < SimpleDelegator
      def initialize(donate_share)
        super
        @donate_share = donate_share
      end

      def calculate_donate_money
        return 0 if @donate_share.empty?

        @donate_share.reduce(0) do |sum, share|
          sum + share.amount
        end
      end
    end
  end
end
