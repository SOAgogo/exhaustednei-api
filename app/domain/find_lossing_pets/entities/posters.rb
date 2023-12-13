# frozen_string_literal: true

require 'dry-types'
require 'dry-struct'

module PetAdoption
  module Entity
    # class Info::adotpers`
    class Posters
      attr_reader :take_care_info

      def initialize(take_care_info, s3_images_url, contact_info, shelter_info, vet_info)
        @take_care_info = take_care_info
        @s3_images_url = s3_images_url
        @contact_info = contact_info
        @shelter_info = shelter_info
        @vet_info = vet_info
      end

      # transfer the animal to the shelter
      def contact_shelters
        shelter_info
      end

      # if the animal is sick, then find the nearest vet or find the greatest vet
      def contact_vet
      end

      def contact_me
      end
    end
  end
end
