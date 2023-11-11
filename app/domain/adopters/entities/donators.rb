# frozen_string_literal: true

require_relative 'normal_people'
module PetAdoption
  module Entity
    # class Donators`
    class Donators < NormalPeople
      attribute :id, Integer.optional
      attribute :donater_id, Strict::Integer, unique: true, null: false
      attribute :shelters, Array::Shelters
      # each element in donate_money is the one gave to the shelter(one-one)
      attribute :donate_money, Array::Integer
      attribute :created_at, Strict::String
      attribute :updated_at, Strict::String

      def pay_money_to_shelter; end
    end
  end
end
