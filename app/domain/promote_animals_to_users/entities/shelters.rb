# frozen_string_literal: true

require 'dry-types'
require 'dry-struct'
require_relative 'animals'
require_relative '../values/shelter_info_stats'
require_relative '../lib/shelter_capacity_counter'

module PetAdoption
  module Entity
    # class Info::Shelter`
    class Shelter
      include PetAdoption::Mixins::ShelterCapacity
      attr_reader :shelter_stats, :shelter_info

      def initialize(shelter_info, animal_obj_list)
        @shelter_info = Value::ShelterInfo.new(shelter_info)
        @shelter_stats = Value::ShelterStats.new(animal_obj_list)
      end

      def to_attr_hash
        shelter_info.to_attr_hash.merge(shelter_stats.to_attr_hash)
      end

      # e.g feature_condition =
      # for api
      def calculate_all_animals_similarity(feature_condition, feature_user_want_ratio)
        shelter_stats.animal_obj_list.map do |_, animal_obj|
          animal_obj.similarity_checking(feature_condition, feature_user_want_ratio)
        end
      end

      # { species:"混種犬" age:"ADULT" color:"黑色" sex:"F" sterilized:true vaccinated:false bodytype:"MEDIUM" }
      # feature_user_want_ratio = [0.2,0.3,0.1,0.4]
      # for api
      def promote_to_user(feature_condition, feature_user_want_ratio, top)
        score_list = calculate_all_animals_similarity(feature_condition, feature_user_want_ratio)
        shelter_stats.animal_obj_list.values.sort_by.with_index { |_, index| score_list[index] }.reverse[0...top]
      end

      def capacity_ratio
        (shelter_stats.animal_num.to_f / shelter_capacity(shelter_info.name[0..2])) * 100
      end
    end
  end
end
