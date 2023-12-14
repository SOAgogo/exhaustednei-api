# frozen_string_literal: true

require 'dry-types'
require 'dry-struct'
module PetAdoption
  # Value objects for animal
  module Value
    # class AnimalFeature`
    class AnimalInfo < Dry::Struct
      include Dry.Types
      attribute :origin_id, Strict::Integer
      attribute :species, String.optional
      attribute :age, Strict::String
      attribute :color, Strict::String
      attribute :sex, Strict::String
      attribute :sterilized, Strict::Bool
      attribute :vaccinated, Strict::Bool
      attribute :bodytype, Strict::String
      attribute :image_url, String.optional
      attribute :registration_date, Strict::Time

      attribute :birth_date, Time.optional
      attribute :health_condition, String.optional
      attribute :personality, String.optional

      def to_attr_hash
        to_hash
      end
    end
  end
end
