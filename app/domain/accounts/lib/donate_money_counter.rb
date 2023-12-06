# frozen_string_literal: true

module PetAdoption
  module Accounts
    # class Info::ShelterMapper`
    class DonateMoneyCounter
      def initialize(donate_money)
        @donate_money = donate_money
      end

      def count
        @donate_money
      end
    end
  end
end
