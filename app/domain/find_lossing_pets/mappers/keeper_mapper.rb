# frozen_string_literal: true

require_relative '../lib/distance_calculator'
require_relative '../repositories/lossing_pets'
require 'pry'

module PetAdoption
  module LossingPets
    # class KeeperMapper`
    class KeeperMapper
      # animal_information is an user-input
      include Mixins::DistanceCalculator

      attr_reader :s3_images_url, :animal_information, :user_info, :users

      def initialize(animal_information, user_info, landmark)
        @s3_images_url = ''
        @animal_information = animal_information # keeper describe animals' traits
        @user_info = user_info # user_info is personal data(email,phone)
        @users = PetAdoption::Repositories::Users.new(@user_info[:county], landmark)
      end

      def images_url(image_path)
        @s3_images_url = image_path
      end

      # set where the animal is lost

      def build_entity(how_far_the_pets_lost, according_to_your_county)
        lossing_pets = find_possible_lossing_pets(how_far_the_pets_lost, according_to_your_county)

        Entity::Keepers.new(lossing_pets, @animal_information, @user_info, @s3_images_url)
      end

      def upload_image(image_path)
        base_url, object_key = @users.upload_image_to_s3(image_path)
        images_url("#{base_url}/#{object_key}")
        @users.s3.make_image_public(object_key)
      end

      def store_user_info
        user_information = @user_info.merge(s3_image_url: @s3_images_url)
        @users.create_db_entity(user_information)
      end

      def lossing_animals(according_to_your_county = false) # rubocop:disable Style/OptionalBooleanParameter
        if according_to_your_county
          @users.find_all_animals_in_county
        else
          @users.find_all_animals
        end
      end

      def determine_two_pictures_similarity(image_url)
        @users.animal_images_path_for_comparison(@s3_images_url, image_url)

        current_output, current_status, other_output, other_status = @users.image_comparison.run
        [current_output, current_status, other_output, other_status]
      end

      def find_possible_lossing_pets(how_far_the_pets_lost, according_to_your_county)
        lost_animals = lossing_animals(according_to_your_county)

        lost_animals.reduce([]) do |acc, animal|
          animal = animal.to_hash

          distance = distance_between_the_point_and_current_location([animal[:latitude],
                                                                      animal[:longtitude]])
          if distance <= how_far_the_pets_lost && (determine_two_pictures_similarity(animal[:s3_image_url]) >= 0.7)
            acc << animal
          end
        end
      end
    end
  end
end
