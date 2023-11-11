# frozen_string_literal: true

require_relative 'account'
# module PetAdoption
module PetAdoption
  module Entity
    # class PetAdoption::Entity::AnimalOrder`
    # when adopters adopt animals, we need to create a new animal order
    # to identify which animal he(she) wants to adopt
    class AnimalOrder < Account
      include Dry.Types
      attribute :adopter_id, Strict::Integer
      attribute :animal_ids, Strict::Array.of(Integer)
      attribute :created_at, Strict::String
      attribute :updated_at, Strict::String
    end
  end
end
