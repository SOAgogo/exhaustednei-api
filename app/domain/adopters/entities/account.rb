# frozen_string_literal: true

require 'dry-struct'
module PetAdoption
  module Entity
    # class Info::adotpers`
    # user inputs from login page
    class Account < Dry::Struct
      include Dry.Types
      attribute :username, Strict::String
      attribute :phone, Strict::String
      attribute :email, Strict::String.optional
      attribute :created_at, Strict::String
      attribute :updated_at, Strict::String
    end
  end
end
