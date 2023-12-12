# frozen_string_literal: true

require 'dry-types'
require 'dry-struct'
# this is for calculating how much a member donate money to a shelter
module PetAdoption
  module Values
    # DonationCalculator
    class ContactInfo < Dry::Struct
      include Dry.Types
      attribute :name, Strict.optional
      attribute :email, Strict.optional
      attribute :phone, Strict.optional
      attribute :county, Strict::String
      attribute :latitude, Strict::Float
      attribute :longitude, Strict::Float
      attribute :picture_path, Strict::String.optional
    end
  end
end
