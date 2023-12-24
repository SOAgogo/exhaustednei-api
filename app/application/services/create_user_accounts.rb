# frozen_string_literal: true

require 'dry/transaction'

module PetAdoption
  module Services
    # class CreateUserAccounts`

    # class PickAnimalShelters`
    class FavoriteListUser
      include Dry::Transaction

      step :get_favorite_list

      private

      def get_favorite_list(input)
        animals = Repository::Adopters::Users.get_animal_favorite_list_by_user(
          input[:session_id], input[:animal_id]
        )
        raise 'animal cannot be added to favorite list' if animals.empty?

        Success(animals:)
      rescue StandardError => e
        Failure(e.message)
      end
    end
  end
end
