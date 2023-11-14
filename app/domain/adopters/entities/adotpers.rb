# frozen_string_literal: true

require_relative 'account'
require_relative 'animal_order'
require_relative '../../shelter_animals/entities/animal'
module PetAdoption
  module Entity
    # class Info::adotpers`
    class Adopters < Account
      include Dry.Types
      attribute :id, Integer.optional
      attribute :adopter_id, Strict::Integer
      attribute :pocket_animals, Strict::Array.of(Animal)
      attribute :animal_order, AnimalOrder
      attribute :created_at, Strict::String
      attribute :updated_at, Strict::String
    end
  end
end
