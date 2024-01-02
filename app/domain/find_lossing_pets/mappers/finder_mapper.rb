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

      def recommends_some_vets(how_far_from_here, top_ratings, type, keyword)
        res, err = users.google_map.find_most_recommendations(how_far_from_here, top_ratings, type, keyword)
        return nil, err if err

        [fetch_useful_information_for_finding_vets(res), nil]
        # rescue GeoLocation::GoogleMapApi::Errors::SearchDistanceTooShort => e
        #   puts e.message
      end

      def give_some_take_care_pets_information
        res = users.take_care_instructions(@s3_images_url)
        fetch_take_care_pets_information(res)
      end

      def build_entity(how_far_from_here = 500, top_ratings = 3)
        vet_info, err = recommends_some_vets(how_far_from_here, top_ratings, 'clinic', 'veterinary')
        raise err unless err.nil?

        take_care_info = give_some_take_care_pets_information
        Entity::Finders.new(take_care_info, @contact_info, vet_info, top_ratings)
      end
    end
  end
end
