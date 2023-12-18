# frozen_string_literal: true

require 'roar/decorator'
require 'roar/json'
require_relative 'animal_list'

module PetAdoption
  module Representer
    # Represents a list of animal IDs
    class AnimalIdList < Roar::Decorator
      include Roar::JSON
      collection :animal_ids, extend: Representer::IntegerRepresenter, class: OpenStruct
    end
  end
end

