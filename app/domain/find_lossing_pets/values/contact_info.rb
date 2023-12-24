# frozen_string_literal: true

require 'dry-types'
require 'dry-struct'
# this is for calculating how much a member donate money to a shelter

module PetAdoption
  # for special type

  # user info
  module Values
    # class ContactInfo`
    class ContactInfo < Dry::Struct
      include Dry.Types
      attribute :name, Strict::String
      attribute :phone_number, Strict::String
      attribute :user_email, Strict::String
      attribute :county, Strict::String
    end
  end
end
