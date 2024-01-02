# frozen_string_literal: true

module PetAdoption
  module Entity
    # class Info::adotpers`
    class Keepers
      attr_reader :pet_traits, :user_info, :lossing_animals_list

      def initialize(lossing_animals_list, animal_information, user_info)
        @lossing_animals_list = Keepers.create_finder(lossing_animals_list)
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
            phone: info[:phone],
            email: info[:email],
            county: info[:county]
          )
        end
      end

      def self.create_finder(lossing_animals_list) # rubocop:disable Metrics/MethodLength
        lossing_animals_list.map do |info|
          PetAdoption::Values::LostAnimalsInfo.new(
            name: info[:name],
            phone: info[:phone],
            email: info[:email],
            county: info[:county],
            species: info[:species],
            s3_image_url: info[:s3_image_url],
            longtitude: info[:longtitude],
            latitude: info[:latitude],
            distance: info[:distance]
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
