# frozen_string_literal: true

require 'pry'
module PetAdoption
  module Entity
    # class Info::adotpers`
    class Keepers
      attr_reader :pet_traits, :user_info, :lossing_animals_list

      def initialize(lossing_animals_list, animal_information, user_info)
        @lossing_animals_list = lossing_animals_list
        @pet_traits = animal_information
        @keeper_info = user_info
      end

      # transfer the ownership of the animal to the keeper
      def how_many_results
        @lossing_animals_list.size
      end

      # watch if there is an animal sitter in database
      def notify_finders
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

      def build_value(user_info)
        PetAdoption::Values::ContactInfo.new(
          name: user_info[:name],
          phone_number: user_info[:phone_number],
          user_email: user_info[:email],
          county: user_info[:county]
        )
      end
    end
  end
end
