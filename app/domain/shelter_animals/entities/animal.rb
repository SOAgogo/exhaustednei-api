# frozen_string_literal: true

# verify your identification
require 'dry-types'
require 'dry-struct'
require 'date'
require_relative 'shelter'
module PetAdoption
  module Entity
    # class Info::Animal`
    class Animal < Dry::Struct
      # attr_reader :animal_id, :animal_area_pkid, :animal_shelter_pkid, :shelter_name, :shelter_address, :shelter_tel
      include Dry.Types
      attribute :id,        Integer.optional
      attribute :remote_id, Strict::Integer
      attribute :cat_or_dog, Cat || Dog
      attribute :species, String.optional
      attribute :age, Strict::String('CHILD' || 'ADULT')
      attribute :color, Strict::String
      attribute :sex, Strict::String
      attribute :sterilized, Strict::Bool
      attribute :vaccinated, Strict::Bool
      attribute :bodytype, Strict::String
      attribute :image_url, String.optional
      attribute :shelter, Shelter
      attribute :registration_date, Strict::DateTime

      def to_attr_hash
        to_hash.except(:id)
      end

      def to_decode_hash
        to_hash.except(:animal_kind,
                       :animal_variate,
                       :animal_found_place,
                       :animal_age,
                       :animal_color,
                       :animal_place)
      end
    end

    # class Info::Cat`
    class Cat < Animal
      include PetAdoption::Mixins::SimilarityCalculator

      def feature
        { 'animal_age' => animal_age, 'color' => color, 'sex' => sex, 'sterilized' => sterilized, 'vaccinated' => vaccinated,
          'bodytype' => bodytype }
      end

      def similarity_checking(animal_feature_user_want_ratio_hash)
        similarity(animal_feature_user_want_ratio_hash, feature)
      end
    end

    # class Info::Dog`
    class Dog < Animal
      include PetAdoption::Mixins::SimilarityCalculator

      def feature
        { 'animal_age' => animal_age, 'color' => color, 'sex' => sex, 'sterilized' => sterilized, 'vaccinated' => vaccinated,
          'bodytype' => bodytype }
      end

      def similarity_checking(animal_feature_user_want_ratio_hash)
        similarity(animal_feature_user_want_ratio_hash, feature)
      end
    end
  end
end
