# frozen_string_literal: true

require 'uri'
require 'dry/monads'

module PetAdoption
  module Request
    # Application value for the path of a requested project
    class PromoteUserAnimals
      include Dry::Monads::Result::Mixin
      def initialize(params)
        @preference = select_preference(params)
        @preference[:color] = URI.decode_www_form_component(@preference[:color])
        @ratio = select_ratio(params)
        @top = params['top'].to_i
      end

      attr_reader :preference, :ratio, :top

      def select_preference(params)
        params.transform_keys(&:to_sym).slice(:age, :sterilized, :bodytype, :sex, :vaccinated, :species, :color)
      end

      def select_ratio(params)
        params.transform_keys { |key| key.to_s.sub(/\Aratio_/, '').to_sym }.transform_values(&:to_f)
          .slice(:age, :sterilized, :bodytype, :sex,
                 :vaccinated, :species, :color)
      end

      def call
        return Failure('input error') if preference.empty? || ratio.empty? || top.zero?

        Success([preference, ratio, top])
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
