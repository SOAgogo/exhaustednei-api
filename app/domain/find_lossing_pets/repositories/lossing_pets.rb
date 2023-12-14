# frozen_string_literal: true

require_relative '../../../infrastructure/geo_location/googlemap_api'
require_relative '../../../infrastructure/gpt/gpt_api'
module PetAdoption
  # Maps over local and remote git repo infrastructure
  module Repositories
    # Repository for UserOrm
    class Users
      # user_info = {'name': 'xxx', 'phone_number': 'xxx', 'email': 'xxx'}
      def initialize
        @google_map = PetAdoption::GeoLocation::GoogleMapApi.new
        @image_conversation = PetAdoption::GptConversation::ImageConversation.new
        @image_comparison = PetAdoption::GptConversation::ImageComparision.new
      end

      def create_db_entity(user_info)
        latitude, longitude = longtitude_latitude
        user_information = user_info.merge(county: google_map.current_location.data['city'],
                                           latitude:,
                                           longitude:)
        Database::ProjectOrm::UserOrm.find_or_create(user_information)
      end

      def animal_image_path(image_path)
        @image_conversation.image_path(image_path)
      end

      def animal_images_path_for_comparison(image_path1, image_path2)
        @image_comparison.image_path(image_path1, image_path2)
      end

      def find_veterinary(how_far_from_your_location, top_ratings = 5)
        google_map.find_popular_veterinary(how_far_from_your_location, top_ratings)
      end

      def find_take_care_instructions(s3_images_url)
        image_comparison.image_path(s3_images_url)
        image_comparison.generate_words_for_takecare_instructions
      end

      def find_all_animals_in_county
        Database::ProjectOrm::LossingPetsOrm.find_all_lost_animals_in_county(@google_map.county)
      end

      def find_all_animals
        Database::ProjectOrm::LossingPetsOrm.all
      end
    end
  end
end
