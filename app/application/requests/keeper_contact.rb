# frozen_string_literal: true

require 'uri'
require 'dry/monads'

module PetAdoption
  module Request
    # Request validation for keeper contact
    class KeeperContact
      include Dry::Monads::Result::Mixin
      def initialize(request)
        @request = KeeperContact.decode(request)
      end

      def self.decode(request) # rubocop:disable Metrics/AbcSize
        req = request.transform_keys(&:to_sym)
        req[:county] = URI.decode_www_form_component(req[:county])
        req[:location] = "#{URI.decode_www_form_component(req[:location])},#{req[:county]}"
        req[:name] = URI.decode_www_form_component(req[:name])
        req[:distance] = req[:distance].to_i
        req[:searchcounty] = req[:searchcounty] == 'true'
        req
      end

      def call
        if @request[:name].empty? || @request[:location].empty? || @request[:distance].zero?
          return Failure('input error')
        end

        Success(
          @request
        )
      end
    end
  end
end
