# frozen_string_literal: true

require 'dry-types'
require 'dry-struct'
# this is for calculating how much a member donate money to a shelter

module PetAdoption
  # for special type
  module Values
    # class ContactInfo`
    class LostAnimalsTraits < Dry::Struct
      include Dry.Types
      attribute :species, Strict::String
      attribute :hair, Strict::String
      attribute :body_type, Strict::String
      attribute :kind, Strict::String
    end
  end
end
