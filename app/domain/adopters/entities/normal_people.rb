# frozen_string_literal: true

module PetAdoption
  module Entity
    # class Info::adotpers`
    class NormalPeople < Dry::Struct
      include Dry.Types

      attribute :username, Strict::String
      attribute :phone, Strict::String
      attribute :email, Strict::Optional

      attribute :created_at, Strict::String
      attribute :updated_at, Strict::String
    end
  end
end
