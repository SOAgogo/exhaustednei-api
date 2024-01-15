# frozen_string_literal: true

require 'dry/monads'
require 'uri'

module PetAdoption
  module Requests
    # Request for vet recommendation
    class VetRecommendation
      include Dry::Monads::Result::Mixin
      def initialize(params, request)
        @params = VetRecommendation.decode(params).transform_keys(&:to_sym)
        @request = request
      end

      def call
        # hash in success
        Success(
          @params
        )
      rescue StandardError
        Failure(
          Response::ApiResult.new(
            status: :bad_request,
            message: 'Cannot parse request body'
          )
        )
      end

      def self.decode(params)
        params['county'] = URI.decode_www_form_component(params['county'])
        params['location'] = "#{URI.decode_www_form_component(params['location'])},#{params['county']}"
        params['name'] = URI.decode_www_form_component(params['name'])
        params['number'] = params['number'].to_i
        params['distance'] = params['distance'].to_i
        params
      end
    end
  end
end
