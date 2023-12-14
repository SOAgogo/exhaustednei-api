# frozen_string_literal: true

require 'dry-types'
require 'dry-struct'

module PetAdoption
  module Entity
    # class Info::adotpers`
    class Posters
      attr_reader :take_care_info

      def initialize(take_care_info, s3_images_url, contact_info, vet_info)
        @take_care_info = take_care_info
        @s3_images_url = s3_images_url
        @contact_info = contact_info
        @vet_info = vet_info
      end

      # transfer the animal to the shelter

      # if the lossing animal is sick, then find the nearest vet or find the greatest vet
      def first_contact_vet
        # find the total_ratings of the vet is at least 300
        popular_vet = vet_info.select { |vet| vet[:total_ratings] >= 300 && vet[:open_time]['open_now'] }
        popular_vet = vet_info.select { vet[:open_time]['open_now'] } if popular_vet.empty?
        popular_vet.max_by { |vet| vet[:rating] }
      end

      def settle_down_animals
        take_care_info
      end

      def contact_me
        @contact_info
      end
    end
  end
end
