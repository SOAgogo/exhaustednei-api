# frozen_string_literal: true

module PetAdoption
  module Request
    # Application value for the path of a requested project
    class ShelterRequestList
      def initialize(shelter_name, animal_kind)
        ak_ch = animal_kind == 'dog' ? '狗' : '貓'
        shelter_name = URI.decode_www_form_component(shelter_name)
        animal_kind = URI.decode_www_form_component(ak_ch)
        
        @shelter_name = shelter_name
        @animal_kind = animal_kind
      end

      attr_reader :shelter_name, :animal_kind

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
