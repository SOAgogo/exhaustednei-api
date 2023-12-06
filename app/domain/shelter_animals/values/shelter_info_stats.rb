# frozen_string_literal: true

require 'dry-types'
require 'dry-struct'
require_relative '../../shelter_animals/entities/animal'

module PetAdoption
  module Value
    # class Info::adotpers`
    class ShelterInfo < Dry::Struct
      include Dry.Types
      # attribute :animal_area_pkid, Strict::Integer
      attribute :id, Integer.optional
      attribute :origin_id, Strict::Integer
      attribute :name, Strict::String
      attribute :address, Strict::String
      attribute :phone_number, Strict::String
      attribute :cat_number, Strict::Integer
      attribute :dog_number, Strict::Integer
      attribute :animal_number, Strict::Integer
      def to_attr_hash
        to_hash.except(:id, :animal_object_list)
      end
    end

    class ShelterStats

      def initialize(animal_obj_list)
        @cat_num = cat_num
        @dog_num = dog_num
        @donate_money = donate_money
        @animal_obj_list = animal_obj_list

      end

      def cat_num
        @cat_num = @animal_obj_list.reduce(0) {
          |sum, (_, animal_obj)| sum + animal_obj.instance_of?(PetAdoption::Entity::Cat) ? 1 : 0
        }
      end


      def dog_num
        @dog_num = @animal_obj_list.reduce(0) {
          |sum, (_, animal_obj)| sum + animal_obj.instance_of?(PetAdoption::Entity::Dog) ? 1 : 0
        }
      end


      def stay_too_long_animals
        include PetAdoption::Mixins::TimeDifferenceCalculator
        @animal_obj_list.reduce(0) {
          |sum, (_, animal_obj)| caculate_time_difference>1000 ? sum + 1 : 0
        }
      end

      def severity_of_old_animals
        ratio = stay_too_long_animals/(cat_num+dog_num) * 100
        "severe" if ratio > 50

        "moderate" if ratio > 30

        "mild"
      end

  end
end
