# frozen_string_literal: true

module PetAdoption
  module LossingPets
    # class KeeperMapper`
    class KeeperMapper
      # animal_information is an user-input
      def initialize(s3_images_url, animal_information, user_info, transfer_pets_ownership = false) # rubocop:disable Style/OptionalBooleanParameter
        @s3_images_url = s3_images_url
        @animal_information = animal_information
        @user_info = user_info # user_info is personal data(email,phone)
        @users = Repository::LossingPets::Users.new
        @users.create_db_entity if transfer_pets_ownership
      end

      def build_entity(how_far_the_pets_lost, _how_long_the_pets_lost, according_to_your_county)
        lossing_pets = find_possible_lossing_pets(how_far_the_pets_lost, _how_long_the_pets_lost,
                                                  according_to_your_county)
        Entity::Keepers.new(lossing_pets[:name], animal_information)
      end

      def lossing_animals(according_to_your_county = false) # rubocop:disable Style/OptionalBooleanParameter
        if according_to_your_county
          users.find_all_animals_in_county
        else
          users.find_all_animals
        end
      end

      def distance_between_two_points(point1)
        users.google_map.distance_between(point1, users.longtiude_latitude) * 1.609344
      end

      def find_possible_lossing_pets(how_far_the_pets_lost, _how_long_the_pets_lost = 0,
                                     according_to_your_county = false) # rubocop:disable Style/OptionalBooleanParameter

        lost_animals = lossing_animals(according_to_your_county)
        lost_animals.reduce([]) do |acc, animal|
          animal = animal.to_hash
          distance = distance_between_two_points([animal['latitude'], animal['longitude']]) * 1.609344
          acc << animal if distance <= how_far_the_pets_lost
        end
      end
    end
  end
end
