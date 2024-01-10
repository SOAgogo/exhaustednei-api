# frozen_string_literal: true

require 'dry-types'
require 'dry-struct'
# this is for calculating how much a member donate money to a shelter

module PetAdoption
  # for special type
  module Values
    # class ContactInfo`
    class TakeCareInfo < Dry::Struct
      include Dry.Types
      attribute :instruction, Strict::String
    end
  end
end
