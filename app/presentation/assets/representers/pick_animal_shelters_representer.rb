# frozen_string_literal: true

require 'roar/decorator'
require 'roar/json'
require_relative 'animal_representer'

module PetAdoption
  module Representer
    # Represents a collection of animals
    class AnimalCollectionDecorator < Roar::Decorator
      include Roar::JSON

      collection :animals, class: OpenStruct, extend: Representer::Animal
    end
  end
end
