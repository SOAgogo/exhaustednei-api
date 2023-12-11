# frozen_string_literal: true

require 'dry-types'
require 'dry-struct'

module PetAdoption
  module Entity
    # class Info::adotpers`
    class Accounts
      def initialize(adopter, keeper, donator, sitter, user_info)
        @adopter = adopter
        @keeper = keeper
        @donator = donator
        @sitter = sitter
        @user_info = PetAdoption::Values::UserInfo.new(user_info)
      end
    end
  end
end
