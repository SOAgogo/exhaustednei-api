# frozen_string_literal: true

require 'dry-types'
require 'dry-struct'
require_relative 'animal_order'
require_relative '../../shelter_animals/entities/animal'
module PetAdoption
  module Entity
    # class Info::adotpers`
    class Adopters
      def initialize(accounts = PetAdoption::Entity::Accounts.new)
        @accounts = accounts
        @animal_order = PetAdoption::Entity::AnimalOrder.new
      end
    end
  end
end
