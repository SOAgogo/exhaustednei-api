# frozen_string_literal: true

module PetAdoption
  module Entity
    # class Info::adotpers`
    # user inputs from login page
    class NormalPeople < Dry::Struct
      include Dry.Types

      attribute :username, Strict::String
      attribute :phone, Strict::String
      attribute :email, Strict::Optional::String
      attribute :created_at, Strict::String
      attribute :updated_at, Strict::String
    end
  end
end
