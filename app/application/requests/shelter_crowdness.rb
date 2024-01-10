# frozen_string_literal: true

require 'uri'
require 'dry/monads'

module PetAdoption
  module Request
    # Request object for shelter crowdedness
    class ShelterCrowdedness
      include Dry::Monads::Result::Mixin
      def initialize(shelter_name)
        @shelter_name = URI.decode_www_form_component(shelter_name)
      end

      attr_reader :shelter_name

      def call
        Success(shelter_name)
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
