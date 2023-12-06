module PetAdoption
  module Value
    class AccumulatedMoney
      attr_reader :accumulated_money
      def initialize(accumulated_money)
        @accumulated_money = accumulated_money
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
