# frozen_string_literal: true

require 'sequel'

module Database
  module ProjectOrm
    # Object-Relational Mapper for Animals
    class LossingPetsOrm < Sequel::Model(:loss_animals)
      plugin :timestamps, update_on_create: true

      def self.find_or_create(user_info)
        first(s3_image_url: user_info[:s3_image_url]) || create(user_info)
      end

      def self.find_all_lost_animals_in_county(county)
        where(county:).all
      end

      def self.find_user_info_by_image_url(s3_image_url)
        where(s3_image_url:).first
      end
    end
  end
end
