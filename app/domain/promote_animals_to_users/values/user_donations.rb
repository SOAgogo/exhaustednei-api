# frozen_string_literal: true

module PetAdoption
  module Value
    # class UserDonations`
    class UserDonations
      attr_reader :accumulated_money

      def initialize
        @accumulated_money = 0
      end

      def add_money(money)
        @accumulated_money += money
      end

      def minus_money(money)
        @accumulated_money -= money
      end
    end
  end
end
