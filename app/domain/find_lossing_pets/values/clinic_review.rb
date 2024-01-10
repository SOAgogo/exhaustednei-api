# frozen_string_literal: true

require 'dry-types'
require 'dry-struct'
# this is for calculating how much a member donate money to a shelter

module PetAdoption
  # for special type
  module Values
    # class ContactInfo`
    class ClinicReview < Dry::Struct
      include Dry.Types
      attribute :name, Strict::String
      attribute :open_time, Strict::Bool
      attribute :which_road, Strict::String
      attribute :address, Strict::String
      attribute :longitude, Strict::Float
      attribute :latitude, Strict::Float
      attribute :rating, Strict::Float
      attribute :total_ratings, Strict::Integer
    end
  end
end
