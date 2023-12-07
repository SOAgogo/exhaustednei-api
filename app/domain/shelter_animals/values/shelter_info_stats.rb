# frozen_string_literal: true

require 'dry-types'
require 'dry-struct'
require_relative '../../shelter_animals/entities/animals'
require_relative '../values/user_donations'
module PetAdoption
  module Value
    # class Info::adotpers`
    class ShelterInfo < Dry::Struct
      include Dry.Types

      attribute :origin_id, Strict::Integer
      attribute :name, Strict::String
      attribute :address, Strict::String
      attribute :phone_number, Strict::String
    end

    # class ShelterStats`
    class ShelterStats
      def initialize(animal_obj_list)
        @animal_obj_list = animal_obj_list
        @cat_num = cat_num
        @dog_num = dog_num
        @donate_money = PetAdoption::Value::UserDonations
      end

      def cat_num
        cat_num = @animal_obj_list.reduce(0) do |sum, (_, animal_obj)|
          sum + (animal_obj.instance_of?(PetAdoption::Entity::Cat) ? 1 : 0)
        end
        0 if cat_num.nil?
        cat_num
      end

      def dog_num
        dog_num = @animal_obj_list.reduce(0) do |sum, (_, animal_obj)|
          sum + (animal_obj.instance_of?(PetAdoption::Entity::Dog) ? 1 : 0)
        end
        0 if dog_num.nil?
        dog_num
      end

      def animal_num
        @cat_num + @dog_num
      end

      def stay_too_long_animals
        include PetAdoption::Mixins::TimeDifferenceCalculator
        old_animal_num = @animal_obj_list.reduce(0) do |sum, (_, animal_obj)|
          caculate_time_difference(animal_obj) > 1000 ? sum + 1 : 0
        end
        0 if old_animal_num.nil?
        old_animal_num
      end

      def severity_of_old_animals
        ratio = stay_too_long_animals / animal_num * 100
        'severe' if ratio > 50

        'moderate' if ratio > 30

        'mild'
      end


    end
  end
end
