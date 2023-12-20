# frozen_string_literal: true

require_relative '../../../infrastructure/geo_location/googlemap_api'
require_relative '../../../infrastructure/gpt/gpt_api'
require 'pry'
module PetAdoption
  # Maps over local and remote git repo infrastructure
  module Repositories
    # Repository for UserOrm
    class Users
      # user_info = {'name': 'xxx', 'phone_number': 'xxx', 'email': 'xxx'}
      attr_reader :google_map, :image_conversation, :image_comparison, :s3

      def initialize(county, landmark)
        @google_map = PetAdoption::GeoLocation::GoogleMapApi.new(county, landmark)
        @image_conversation = PetAdoption::GptConversation::ImageConversation.new
        @image_comparison = PetAdoption::ImageRecognition::Classification.new
        @s3 = PetAdoption::Storage::S3.new
      end

      # user_info is a hash with name,phone_number,county
      def create_db_entity(user_info)
        latitude, longtitude = google_map.longtitude_latitude
        user_information = user_info.merge(
          latitude:,
          longtitude:
        )

        Database::ProjectOrm::LossingPetsOrm.find_or_create(user_information)
      end

      def find_all_animals_in_county
        Database::ProjectOrm::LossingPetsOrm.find_all_lost_animals_in_county(@google_map.county)
      end

      def find_all_animals
        Database::ProjectOrm::LossingPetsOrm.all
      end

      def find_user_info_by_image_url(s3_image_url)
        Database::ProjectOrm::LossingPetsOrm.find_user_info_by_image_url(s3_image_url)
      end

      def animal_images_path_for_comparison(image_path1, image_path2)
        @image_comparison.image_path(image_path1, image_path2)
      end

      def find_veterinary(how_far_from_your_location, top_ratings = 5)
        google_map.find_popular_veterinary(how_far_from_your_location, top_ratings)
      end

      def find_take_care_instructions(s3_images_url)
        @image_conversation.image_path(s3_images_url)
        @image_conversation.generate_words_for_takecare_instructions
      end

      def upload_image_to_s3(image_path)
        PetAdoption::Storage::S3.upload_image_to_s3(image_path)
      end
    end
  end
end
