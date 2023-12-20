# frozen_string_literal: true

module PetAdoption
  module LossingPets
    # class KeeperMapper`
    class PosterMapper
      # animal_information is an user-input
      def initialize(user_info)
        @s3_images_url = ''
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

      def images_url(image_path)
        @s3_images_url = image_path
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

      def fetch_take_care_pets_information(res)
        res.match(/content='(.+?)'/)[1]
      end

      def recommends_some_vets(how_far_from_here, top_ratings, type, keyword)
        res = users.find_most_recommendations(how_far_from_here, top_ratings, type, keyword)
        fetch_useful_information_for_finding_vets(res)
      end

      def give_some_take_care_pets_information
        res = users.find_take_care_instructions(@s3_images_url)
        fetch_take_care_pets_information(res)
      end

      # def find_the_nearest_shelter(how_far_from_here)
      #   find_nearest(how_far_from_here, 'shelter', 'animal%20shelter')
      # end

      def build_entity(how_far_from_here = 500, top_ratings = 5)
        vet_info = recommends_some_vets(how_far_from_here, top_ratings, 'veterinary_care', 'pet%20clinic')
        take_care_info = give_some_take_care_pets_information
        # shelter_info = find_the_nearest_shelter(how_far_from_here, 'shelter', 'animal%20shelter')
        Entity::Posters.new(take_care_info, s3_images_url, contact_info, vet_info)
      end
    end
  end
end
