# frozen_string_literal: true

require 'uri'
require 'dry/monads'

module PetAdoption
  module Request
    # Application value for the path of a requested project
    class AnimalScore
      include Dry::Monads::Result::Mixin
      def initialize(params)
        @preference = params.except('animal_id').transform_keys(&:to_sym)
        @preference[:color] = URI.decode_www_form_component(@preference[:color])
        @animal_id = params['animal_id'].to_i
      end

      attr_reader :preference, :animal_id

      def call
        return Failure('input error') if preference.empty? || animal_id.zero?

        feature_user_want_ratio = { age: 1, sterilized: 1, bodytype: 1, sex: 1, vaccinated: 1, species: 1, color: 1 }
        Success([animal_id, preference, feature_user_want_ratio])
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
