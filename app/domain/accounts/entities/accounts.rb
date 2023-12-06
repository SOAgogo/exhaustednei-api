# frozen_string_literal: true

require 'dry-types'
require 'dry-struct'

module PetAdoption
  module Entity
    # class Info::adotpers`
    class Accounts
      def initialize(adopter, keeper, donator, sitter)
        @adopter = adopter
        @keeper = keeper
        @donator = donator
        @sitter = sitter
      end

    end
  end
end
