# frozen_string_literal: true

require_relative 'normal_people'
require_relative 'animal_order'
require_relative '../../shelter_animals/entities/animal'
module PetAdoption
  module Entity
    # class Info::adotpers`
    class Adopters < NormalPeople
      include Dry.Types
      attribute :id, Integer.optional
      attribute :adopter_id, Strict::Integer, unique: true, null: false
      attribute :animals, Array::Animals
      attribute :animal_order, AnimalOrder
      attribute :created_at, Strict::String
      attribute :updated_at, Strict::String
    end
  end
end
