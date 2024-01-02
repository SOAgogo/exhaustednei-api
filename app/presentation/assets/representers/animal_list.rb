# frozen_string_literal: true

require 'roar/decorator'
require 'roar/json'

module PetAdoption
  module Representer
    # Represents an individual integer
    class IntegerRepresenter < Roar::Decorator
      include Roar::JSON

      property :value
    end
  end
end
