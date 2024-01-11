# frozen_string_literal: true

module PetAdoption
  module LossingPets
    # class KeeperMapper`
    class FinderMapper
      class Errors
        DuplicateS3FileName = Class.new(StandardError)
      end

      attr_reader :s3_images_url, :contact_info, :users

      def initialize(user_info, landmark)
        @s3_images_url = ''
        @contact_info = user_info # user_info is personal data(email,phone)
        @users = PetAdoption::Repositories::Users.new(user_info[:county], landmark)
      end

      def fetch_useful_information_for_finding_vets(res) # rubocop:disable Metrics/MethodLength,Metrics/AbcSize
        res.map do |result|
          open_info = result['opening_hours'].nil? ? false : result['opening_hours']['open_now']
          { name: result['name'],
            # open_time: result['opening_hours']['open_now'],
            open_time: open_info,
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

      def image_recoginition
        @users.image_classification.run(@s3_images_url)
      end

      def store_user_info
        user_information = @contact_info.merge(s3_image_url: @s3_images_url,
                                               species: @users.image_classification.species,
                                               keeper_or_finder: false)
        @users.create_db_entity(user_information)
      end

      def fetch_take_care_pets_information(res)
        if res.match(/content='(.+?)'/).nil?
          'No take care instructions'
        else
          res.match(/content='(.+?)'/)[1]
        end
      end

      def recommends_some_vets(how_far_from_here, top_ratings)
        res, err = users.google_map.find_most_recommendations(how_far_from_here, top_ratings, 'clinic', 'veterinary')
        return nil, err if err

        [fetch_useful_information_for_finding_vets(res), nil]
      end

      def give_some_take_care_pets_information
        res = users.take_care_instructions(@s3_images_url)
        fetch_take_care_pets_information(res)
      end

      # TODO: parallize doing the recognition and the google map api
      def build_entity(useful_info, take_care_info)
        # two worker queues for recommends_some_vets and give_some_take_care_pets_information
        # vet_info, err = recommends_some_vets(how_far_from_here, top_ratings, 'clinic', 'veterinary')
        # raise err unless err.nil?

        # take_care_info = give_some_take_care_pets_information
        Entity::Finders.new(take_care_info, @contact_info, useful_info[0], top_ratings)
      end
    end
  end
end
