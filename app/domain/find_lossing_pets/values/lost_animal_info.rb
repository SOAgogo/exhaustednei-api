# frozen_string_literal: true

require 'dry-types'
require 'dry-struct'
# this is for calculating how much a member donate money to a shelter

module PetAdoption
  # for special type
  module Values
    # class ContactInfo`
    class LostAnimalsInfo < Dry::Struct
      include Dry.Types
      attribute :name, Strict::String
      attribute :phone, Strict::String
      attribute :email, Strict::String
      attribute :county, Strict::String
      attribute :species, Strict::String
      attribute :s3_image_url, Strict::String
      attribute :longtitude, Strict::Float
      attribute :latitude, Strict::Float
      attribute :distance, Strict::Float
    end
  end
end
