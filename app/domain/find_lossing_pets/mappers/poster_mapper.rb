# frozen_string_literal: true

module PetAdoption
  module LossingPets
    # class KeeperMapper`
    class PosterMapper
      # animal_information is an user-input
      def initialize(s3_images_url, user_info)
        @s3_images_url = s3_images_url
        @contact_info = user_info # user_info is personal data(email,phone)
        @users = Repository::LossingPets::Users.new
      end

      def fetch_useful_information_for_finding_vets(res)
        res.map do |result|
          { name: result['name'],
            open_time: result['opening_hours'],
            which_road: result['vicinity'],
            address: result['plus_code']['compound_code'],
            longitude: result['geometry']['location']['lng'],
            latitude: result['geometry']['location']['lat'],
            rating: result['rating'],
            total_ratings: result['user_ratings_total'] }
        end
      end

      def fetch_take_care_pets_information(res)
        res.match(/content='(.+?)'/)[1]
      end

      def recommends_some_vets(how_far_from_here = 500, top_ratings = 5)
        res = users.find_veterinary(how_far_from_here, top_ratings)
        fetch_useful_information_for_finding_vets(res)
      end

      def give_some_take_care_pets_information
        res = users.find_take_care_instructions(s3_images_url)
        fetch_take_care_pets_information(res)
      end

      def build_entity(how_far_from_here = 500, top_ratings = 5)
        vet_info = recommends_some_vets(how_far_from_here, top_ratings)
        take_care_info = give_some_take_care_pets_information
        Entity::Posters.new(take_care_info, s3_images_url, contact_info, vet_info)
      end
    end
  end
end
