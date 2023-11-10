# frozen_string_literal: true

# module PetAdoption
module PetAdoption
  modue Entity
  # class PetAdoption::Entity::AnimalOrder`
  # when adopters adopt animals, we need to create a new animal order
  # to identify which animal he(she) wants to adopt
  class AnimalOrder < Dry::Struct
    include Dry.Types

    attribute :animal_id, Strict::Integer
    attribute :adopter_id, Strict::Integer
    attribute :created_at, Strict::String
    attribute :updated_at, Strict::String
  end
end
