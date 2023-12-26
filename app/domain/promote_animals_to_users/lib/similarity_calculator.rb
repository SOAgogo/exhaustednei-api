# frozen_string_literal: true

# create an animal object instance
module PetAdoption
  module Mixins
    # class SimilarityCalculator`
    module SimilarityCalculator
      def similarity(feature_condition, feature_user_want_ratio, feature)
        similarity_score = 0
        feature_condition.each do |key, value|
          similarity_score += feature_user_want_ratio[key] if feature[key.to_s] == value
        end
        similarity_score
      end
    end
  end
end
