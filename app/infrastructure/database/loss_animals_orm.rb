# frozen_string_literal: true

require 'sequel'

module Database
  module ProjectOrm
    # Object-Relational Mapper for Animals
    class LossingPetsOrm < Sequel::Model(:loss_animals)
      plugin :timestamps, update_on_create: true

      # can't accept the same s3_image_url
      def self.lost_animals_create(user_info)
        return false unless first(s3_image_url: user_info[:s3_image_url]).nil?

        create(user_info)
      end

      def self.find_all_lost_animals_in_county(county)
        where(county:, keeper_or_finder: false).all
      end

      def self.find_all_lost_animals_in_country
        where(keeper_or_finder: false).all
      end

      def self.find_user_info_by_image_url(s3_image_url)
        where(s3_image_url:).first
      end

      def self.s3_image_uploaded_or_not(s3_image_url)
        return true if where(s3_image_url:).first

        false
      end
    end
  end
end
