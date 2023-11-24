# frozen_string_literal: true

module PetAdoption
  module Services
    # class CreateUserAccounts`
    class CreateUserAccounts
      def initialize(cookie_hash)
        @cookie_hash = cookie_hash
      end

      def call
        user = PetAdoption::Adopters::AccountMapper.new(@cookie_hash).find
        Repository::Adopters::Users.new(
          user.to_attr_hash.merge(
            address: URI.decode_www_form_component(user.address)
          )
        ).create_user
      end
    end

    # class PickAnimalShelters`
    class FavoriteListUser
      def self.call(session_id, animal_id)
        Repository::Adopters::Users.get_animal_favorite_list_by_user(
          session_id, animal_id
        )
      end
    end
  end
end
