# frozen_string_literal: true

require 'dry-types'
require 'dry-struct'
require_relative '../entities/animals'
require_relative 'user_donations'
require_relative '../lib/time_difference_calculator'
module PetAdoption
  module Value
    # class Info::adotpers`
    class ShelterInfo < Dry::Struct
      include Dry.Types

      attribute :origin_id, Strict::Integer
      attribute :name, Strict::String
      attribute :address, Strict::String
      attribute :phone_number, Strict::String

      def to_attr_hash
        {
          origin_id:,
          name:,
          address:,
          phone_number:
        }
      end
    end

    # class ShelterStats`
    class ShelterStats
      include PetAdoption::Mixins::TimeDifferenceCalculator
      attr_reader :animal_obj_list, :donate_money, :cat_num, :dog_num

      def initialize(animal_obj_list)
        @animal_obj_list = animal_obj_list
        @cat_num = calculate_cat_num
        @dog_num = calculate_dog_num
        @donate_money = PetAdoption::Value::UserDonations.new
      end

      def to_attr_hash
        {
          cat_num:,
          dog_num:,
          donate_money: donate_money.accumulated_money
        }
      end

      def calculate_cat_num
        cat_num = @animal_obj_list.reduce(0) do |sum, (_, animal_obj)|
          sum + (animal_obj.instance_of?(PetAdoption::Entity::Cat) ? 1 : 0)
        end
        0 if cat_num.nil?
        cat_num
      end

      def calculate_dog_num
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
        old_animal_num = @animal_obj_list.reduce(0) do |sum, (_, animal_obj)|
          # animal stay over 1000 days is too old
          calculate_time_difference(animal_obj) > 1000 ? sum + 1 : 0
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
