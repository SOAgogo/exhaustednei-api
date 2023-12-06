# frozen_string_literal: true

require 'dry-types'
require 'dry-struct'
module PetAdoption
  module Value
    # class AnimalFeature`
    class AnimalInfo < Dry::Struct
      include Dry.Types
      attribute :remote_id, Strict::Integer
      attribute :species, String.optional
      attribute :age, Strict::String
      attribute :color, Strict::String
      attribute :sex, Strict::String
      attribute :sterilized, Strict::Bool
      attribute :vaccinated, Strict::Bool
      attribute :bodytype, Strict::String
      attribute :image_url, String.optional
      attribute :registration_date, Strict::DateTime
    end
  end
end
