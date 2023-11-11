# frozen_string_literal: true

require_relative 'normal_people'
require_relative '../../shelter_animals/entities/shelter'
module PetAdoption
  module Entity
    # class Donators`
    class Donators < NormalPeople
      attribute :id, Integer.optional
      attribute :donater_id, Strict::Integer
      attribute :shelters, Strict::Array.of(Shelter)
      # each element in donate_money is the one gave to the shelter(one-one)
      attribute :donate_money, Strict::Array.of(Integer)
      attribute :created_at, Strict::String
      attribute :updated_at, Strict::String

      def pay_money_to_shelter; end
    end
  end
end
