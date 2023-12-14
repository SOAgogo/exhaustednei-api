# frozen_string_literal: true

module PetAdoption
  module Entity
    # class Info::adotpers`
    class Keepers
      attr_reader :pet_traits, :pet_picture_path

      def initialize(lossing_animals_list, animal_information, user_info, s3_images_url)
        @lossing_animals_list = lossing_animals_list
        @pet_traits = animal_information
        @user_info = user_info
        @s3_images_url = s3_images_url
      end

      # transfer the ownership of the animal to the keeper
      def how_many_similar_results
        @lossing_animals_list.size
      end

      # watch if there is an animal sitter in database
      def notify_posters
        # send email to the user
        information = []
        lossing_animals_list.each_with_object({}) do |info, hash|
          hash['name'] = info['name'] if info['name'] != ''
          hash['phone_number'] = info['phone_number']
          hash['email'] = info['email']
          information << hash
        end
        information
      end

      def contact_me
        information_hash = {}
        information_hash['name'] = @user_info['name']
        information_hash['phone_number'] = @user_info['phone_number']
        information_hash['email'] = @user_info['email']
        information_hash['animal_traits'] = @pet_traits
        information_hash
      end
    end
  end
end
