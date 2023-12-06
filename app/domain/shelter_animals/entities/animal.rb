# frozen_string_literal: true

# verify your identification
require 'dry-types'
require 'dry-struct'
require 'date'
require_relative 'shelter'
module PetAdoption
  module Entity
    # class Info::Animal`
    class Animal
      # attr_reader :animal_id, :animal_area_pkid, :animal_shelter_pkid, :shelter_name, :shelter_address, :shelter_tel

      def initialize(feature)
        @feature = Value::AnimalFeature.new(feature)
      end

      def feature
        { 'animal_age' => animal_age, 'color' => color, 'sex' => sex, 'sterilized' => sterilized, 'vaccinated' => vaccinated,
          'bodytype' => bodytype }
      end
    end

    # class Info::Cat`
    class Cat < Animal
      include PetAdoption::Mixins::SimilarityCalculator

      def similarity_checking(animal_feature_user_want_ratio_hash)
        similarity(animal_feature_user_want_ratio_hash, feature)
      end
    end

    # class Info::Dog`
    class Dog < Animal
      include PetAdoption::Mixins::SimilarityCalculator

      def similarity_checking(animal_feature_user_want_ratio_hash)
        similarity(animal_feature_user_want_ratio_hash, feature)
      end
    end
  end
end
