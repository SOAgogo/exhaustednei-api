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

      def build_entity(how_far_the_pets_lost, according_to_your_county)
        lossing_pets = find_possible_lossing_pets(how_far_the_pets_lost, according_to_your_county)
        Entity::Keepers.new(lossing_pets, @animal_information, @user_info)
      end

      def image_name_duplicate?(base_url, object)
        s3_url = "#{base_url}/#{object}"
        true if users.s3_image_uploaded_or_not?(s3_url)
        false
      end

      # first upload_image and then store_user_info
      def upload_image(image_path)
        base_url, object = PetAdoption::Storage::S3.object_url(image_path)
        raise Errors::DuplicateS3FileName if image_name_duplicate?(base_url, object)

        @users.upload_image_to_s3(image_path)
        images_url("#{base_url}/#{object}")
        @users.s3.make_image_public(object)
        @users.image_classification.run(@s3_images_url)
      end

      def store_user_info
        user_information = @user_info.merge(s3_image_url: @s3_images_url,
                                            species: @users.image_classification.species,
                                            address: @users.google_map.address,
                                            keeper_or_finder: true)
        @users.create_db_entity(user_information)
      end

      def lossing_animals(according_to_your_county = false) # rubocop:disable Style/OptionalBooleanParameter
        if according_to_your_county
          @users.find_all_animals_in_county
        else
          @users.find_all_animals
        end
      end

      def find_possible_lossing_pets(how_far_the_pets_lost, according_to_your_county)
        lost_animals = lossing_animals(according_to_your_county)
        binding.pry

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
