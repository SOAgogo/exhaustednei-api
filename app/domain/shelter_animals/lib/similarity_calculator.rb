# frozen_string_literal: true

# create an animal object instance
module PetAdoption
  module Mixins
    # class SimilarityCalculator`
    module SimilarityCalculator
      def similarity(animal_feature_user_want_ratio_hash, feature)
        feature.reduce(0) do |sum, (key, _value)|
          if animal_feature_user_want_ratio_hash.key?(key) && animal_feature_user_want_ratio_hash[key] != 0
            sum += animal_feature_user_want_ratio_hash[key] * 0.01
          end
          sum
        end
      end
    end
  end
end
