# frozen_string_literal: true
require 'dry-types'
require 'dry-struct'
require_relative 'animal_order'
require_relative '../../shelter_animals/entities/animal'
module PetAdoption
  module Entity
    # class Info::adotpers`
    class Adopters < Dry::Struct
      include Dry.Types
      attribute :session_id, Strict::String
      attribute :firstname, Strict::String
      attribute :lastname, Strict::String
      attribute :phone, Strict::String
      attribute :email, Strict::String.optional
      attribute :address, Strict::String.optional
      attribute :donate_money, Strict::Integer
      # attribute :animal_order, AnimalOrder
      def to_attr_hash
        to_hash.except(:address)
      end
    end
  end
end
