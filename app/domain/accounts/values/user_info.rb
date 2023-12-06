# frozen_string_literal: true

require 'dry-struct'
require 'dry-types'
module PetAdoption
  module Values
    # class UserInfo`
    class UserInfo < Dry::Struct
      include Dry.Types
      attribute :name, Strict::String
      attribute :phone, Strict::String
      attribute :email, Strict::String.optional
      attribute :address, Strict::String.optional
      attribute :birthday, Strict::DateTime
    end
  end
end
