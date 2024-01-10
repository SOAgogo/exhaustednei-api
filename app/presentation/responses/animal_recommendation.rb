# frozen_string_literal: true

module PetAdoption
  module Response
    RecommendationScores = Struct.new(:shelter_name, :recommend_animal, :scores)
    RecommendationScoresList = Struct.new(:recommendation)
  end
end
