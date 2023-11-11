# frozen_string_literal: true

require_relative '../../shelter_animals/entities/animal'
require_relative 'animal_order'
require_relative 'normal_people'

module PetAdoption
  module Entity
    # class Info::adotpers`
    class Keepers < NormalPeople
      include Dry.Types
      attribute :id, Integer.optional
      attribute :animals, Strict::Array.of(Animal)
      attribute :keeper_id, Strict::Integer
      attribute :created_at, Strict::String
      attribute :updated_at, Strict::String
    end
  end
end
