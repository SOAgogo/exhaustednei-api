# frozen_string_literal: true

require_relative '../lib/distance_calculator'
require_relative '../repositories/lossing_pets'

module PetAdoption
  module LossingPets
    # class KeeperMapper`
    class KeeperMapper
      class Errors
        DuplicateS3FileName = Class.new(StandardError)
      end
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

      def build_entity(how_far_the_pets_lost, according_to_your_county, county)
        lossing_pets = find_possible_lossing_pets(how_far_the_pets_lost, according_to_your_county, county)
        Entity::Keepers.new(lossing_pets, @animal_information, @user_info)
      end

      def image_recoginition
        @users.image_classification.run(@s3_images_url)
      end

      def store_user_info
        user_information = @user_info.merge(s3_image_url: @s3_images_url,
                                            species: @users.image_classification.species,
                                            address: @users.google_map.address,
                                            keeper_or_finder: true)
        @users.create_db_entity(user_information)
      end

      def lossing_animals(county, according_to_your_county)
        if according_to_your_county
          @users.find_all_animals_in_county(county)
        else
          @users.find_all_animals
        end
      end

      def find_possible_lossing_pets(how_far_the_pets_lost, according_to_your_county, county)
        lost_animals = lossing_animals(county, according_to_your_county)

        lost_animals.each_with_object([]) do |animal, acc|
          animal = animal.to_hash.except(:created_at, :updated_at, :id, :address)
          distance = distance_between_the_point_and_current_location([animal[:latitude],
                                                                      animal[:longtitude]])
          animal[:distance] = distance
          acc << animal if distance <= how_far_the_pets_lost
        end
      end
    end
  end
end
