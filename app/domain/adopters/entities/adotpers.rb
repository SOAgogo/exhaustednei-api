# frozen_string_literal: true

require_relative 'animal_order'
module PetAdoption
  module Entity
    # class Info::adotpers`
    class Adopters < Dry::Struct
      include Dry.Types
      attribute :id, Integer.optional
      attribute :animal_id, Strict::Integer
      attribute :animal_order, AnimalOrder
      attribute :adopter_id, Strict::Integer
      attribute :created_at, Strict::String
      attribute :updated_at, Strict::String
    end
  end
end
