# frozen_string_literal: true

require 'dry-types'
require 'dry-struct'
require_relative 'animals'
require_relative '../values/shelter_info_stats'
require_relative '../lib/types'
module PetAdoption
  module Entity
    # class Info::Shelter`
    class Shelter
      def initialize(shelter_info, animal_obj_list)
        @shelter_info = Value::ShelterInfo.new(shelter_info)
        @shelter_stats = Value::ShelterStats.new(animal_obj_list)
        @animal_object_list = animal_obj_list
      end

      def calculate_all_animals_similarity(feature_condition, feature_user_want_ratio)
        @animal_object_list.map do |_, animal_obj|
          animal_obj.similarity_checking(feature_condition, feature_user_want_ratio)
        end
      end

      # e.g feature_condition =
      # { species:"混種犬" age:"ADULT" color:"黑色" sex:"F" sterilized:true vaccinated:false bodytype:"MEDIUM" }
      # feature_user_want_ratio = [0.2,0.3,0.1,0.4]
      def promote_to_user(feature_condition, feature_user_want_ratio, top)
        score_list = calculate_all_animals_similarity(feature_condition, feature_user_want_ratio)
        # get the animals of top n score
        @animal_object_list.values.sort_by.with_index { |_, index| score_list[index] }.reverse[0...top]
      end
    end
  end
end
