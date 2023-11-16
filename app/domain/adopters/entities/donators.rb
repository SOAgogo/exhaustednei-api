# frozen_string_literal: true

require 'dry-types'
require 'dry-struct'
# 處理donator部分
require_relative '../../shelter_animals/entities/shelter'
module PetAdoption
  module Entity
    # class Donators`
    class Donators < Dry::Struct
      # attribute :shelters, Strict::Array.of(Shelter)
      # each element in donate_money is the one gave to the shelter(one-one)
      include Dry.Types
      attribute :session_id, Strict::String
      attribute :firstname, Strict::String
      attribute :lastname, Strict::String
      attribute :phone, Strict::String
      attribute :email, Strict::String.optional
      attribute :address, Strict::String.optional
      attribute :donate_money, Strict::Integer

      def to_attr_hash
        to_hash.except(:address)
      end

      def pay_money_to_shelter(shelter_pkid, amount)
        shelter = shelters.find { |shelter| shelter.id == shelter_pkid }
        shelter.money += amount
      end
    end
  end
end
