# frozen_string_literal: true

module PetAdoption
  module Entity
    # class Info::adotpers`
    class Keepers
      attr_reader :pet_traits, :user_info, :lossing_animals_list

      def initialize(lossing_animals_list, animal_information, user_info)
        @lossing_animals_list = lossing_animals_list
        @pet_traits = animal_information
        @keeper_info = PetAdoption::Values::ContactInfo.new(user_info)
        @finder_info = create_finder_info(lossing_animals_list)
      end

      # transfer the ownership of the animal to the keeper
      def how_many_results
        @lossing_animals_list.size
      end

      def create_finder_info(lossing_animals_list)
        lossing_animals_list.each_with_object({}) do |info, hash|
          hash[info[:name]] = PetAdoption::Values::ContactInfo.new(
            name: info[:name],
            phone_number: info[:phone_number],
            user_email: info[:user_email],
            county: info[:county]
          )
        end
      end


      # watch if there is an animal sitter in database
      def notify_finders
        @finder_info.values
      end

      def contact_me
        @keeper_info
      end
    end
  end
end
