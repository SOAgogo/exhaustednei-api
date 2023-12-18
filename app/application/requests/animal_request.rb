# frozen_string_literal: true

module PetAdoption
  module Request
    # Application value for the path of a requested project
    class AnimalRequest
      def initialize(animal_id)
        @animal_id = animal_id
      end

      attr_reader :animal_id

      # Use in API to parse incoming list requests
      def call
        Success(
          JSON.parse(decode(@animal_kind))
        )
      rescue StandardError
        Failure(
          Response::ApiResult.new(
            status: :bad_request,
            message: 'Project list not found'
          )
        )
      end
    end
  end
end
