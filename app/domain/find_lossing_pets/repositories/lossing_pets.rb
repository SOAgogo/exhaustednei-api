# frozen_string_literal: true

require '../../../infrastructure/geo_location/googlemap_api'
require '../../../infrastructure/gpt/gpt_api'
module Repository
  # Maps over local and remote git repo infrastructure
  module LossingPets
    # Repository for UserOrm
    class Users
      # user_info = {'name': 'xxx', 'phone_number': 'xxx', 'email': 'xxx'}
      def initialize
        @google_map = PetAdoption::GeoLocation::GoogleMapApi.new
        @image_recognition = PetAdoption::GptConversation::ImageConversation.new(image_path)
      end

      def longtiude_latitude
        latitude, longitude = google_map.current_location['loc'].split(',')
        [latitude, longitude]
      end

      def create_db_entity
        latitude, longitude = longtiude_latitude
        user_information = user_info.merge(county: current_location.data['city'],
                                           latitude:,
                                           longitude:)
        Database::ProjectOrm::UserOrm.find_or_create(user_information)
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
