# frozen_string_literal: true

require 'uri'
require 'dry/monads'

module PetAdoption
  module Request
    # Application value for the path of a requested project
    class AnimalLister
      include Dry::Monads::Result::Mixin
      def initialize(animal_kind, shelter_name)
        @shelter_name = URI.decode_www_form_component(shelter_name)
        @animal_kind = URI.decode_www_form_component(animal_kind)
      end

      attr_reader :shelter_name, :animal_kind

      # helper method

      def call
        return Failure('input error') if animal_kind == ''

        Success([animal_kind, shelter_name])
      rescue StandardError
        Failure(
          Response::ApiResult.new(
            status: :bad_request,
            message: 'Cannot parse request body'
          )
        )
      end
    end
  end
end
