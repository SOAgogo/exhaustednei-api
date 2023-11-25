# frozen_string_literal: true

require 'dry/transaction'
require 'pry'
module PetAdoption
  module Services
    # class CreateUserAccounts`
    class CreateUserAccounts
      include Dry::Transaction

      # def initialize(cookie_hash)
      #   @cookie_hash = cookie_hash
      # end
      step :create_user_account
      step :store_user_account

      private

      def create_user_account(input)
        if input[:url_request].success?
          covert_key_to_s = input[:url_request].to_h.transform_keys(&:to_s)
          user = PetAdoption::Adopters::AccountMapper.new(covert_key_to_s).find

          Success(user:)
        else
          Failure('User entity creation failed')
        end
      end

      def store_user_account(user)
        db_user = Repository::Adopters::Users.new(
          user[:user].to_attr_hash.merge(
            address: URI.decode_www_form_component(user[:user].address)
          )
        ).create_user
        if db_user.session_id.nil?
          Failure('User cannot be stored in Database')
        else
          Success(db_user:)
        end
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
