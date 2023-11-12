# frozen_string_literal: true

# this is for calculating how much a member donate money to a shelter
module PetAdoption
  module Donation
    # DonationCalculator
    class DonationCalculator < SimpleDelegator
      def initialize(donate_share)
        super
        @donate_share = donate_share
      end
    end
  end
end
