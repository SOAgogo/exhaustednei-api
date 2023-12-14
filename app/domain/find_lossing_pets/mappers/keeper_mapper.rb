# frozen_string_literal: true

require_relative '../lib/distance_calculator'
module PetAdoption
  module LossingPets
    # class KeeperMapper`
    class KeeperMapper
      # animal_information is an user-input
      include Mixins::DistanceCaculator
      def initialize(s3_images_url, animal_information, user_info)
        @s3_images_url = s3_images_url
        @animal_information = animal_information
        @user_info = user_info # user_info is personal data(email,phone)
        @users = Repository::LossingPets::Users.new
      end

      def transfer_pets_ownership
        @users.create_db_entity(user_info)
      end

      def build_entity(how_far_the_pets_lost, _how_long_the_pets_lost, according_to_your_county)
        lossing_pets = find_possible_lossing_pets(how_far_the_pets_lost, _how_long_the_pets_lost,
                                                  according_to_your_county)
        Entity::Keepers.new(lossing_pets[:name], animal_information, user_info, s3_images_url)
      end

      def lossing_animals(according_to_your_county = false) # rubocop:disable Style/OptionalBooleanParameter
        if according_to_your_county
          users.find_all_animals_in_county
        else
          users.find_all_animals
        end
      end

      def determine_two_pictures_similarity(image_url)
        users.animal_images_path_for_comparison(@s3_images_url, image_url)
        users.image_comparison.generate_similarity
      end

      def find_possible_lossing_pets(how_far_the_pets_lost, _how_long_the_pets_lost = 0,
                                     according_to_your_county = false) # rubocop:disable Style/OptionalBooleanParameter

        lost_animals = lossing_animals(according_to_your_county)
        lost_animals.reduce([]) do |acc, animal|
          animal = animal.to_hash
          distance = distance_between_the_point_and_current_location([animal['latitude'],
                                                                      animal['longitude']])
          if distance <= how_far_the_pets_lost && (determine_two_pictures_similarity(animal['s3_image_url']) > 0.5)
            acc << animal
          end
        end
      end
    end
  end
end
