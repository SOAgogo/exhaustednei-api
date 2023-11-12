# frozen_string_literal: true

module PetAdoption
  module Account # for verifying user's account
    # This is the class for creating a new account
    class CreateAccount
      def initialize(repo)
        @repo = repo
      end

      def call(params)
        @repo.create(params)
      end
    end
  end
end
