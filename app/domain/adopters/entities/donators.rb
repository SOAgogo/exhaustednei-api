# frozen_string_literal: true

module PetAdoption
  module Entity
    class Donators < Dry::Struct
      include Dry.Types
      attribute :id, Integer.optional
      attribute :adopter_id, Strict::Integer
      attribute :donate_money, Strict::Integer
      attribute :created_at, Strict::String
      attribute :updated_at, Strict::String
    end
  end
end
