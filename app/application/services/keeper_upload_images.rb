# frozen_string_literal: true

require 'dry/transaction'

module PetAdoption
  module Services
    # class ImageRecognition`
    class KeeperUploadImages
      include Dry::Transaction
      step :validate_input
      step :create_keeper_mapper
      step :setting_keeper_info
      step :create_keeper_info

      private

      def validate_input(input)
        request = input[:req].call
        request_value = request.value!
        if request_value[:file].nil? || request_value[:distance].nil? || request_value[:searchcounty].nil?
          Failure('Please upload a photo and fill in the distance and the county')
        end
        Success(request)
      end

      def create_keeper_mapper(input)
        input = input.value!

        keeper_mapper = PetAdoption::LossingPets::KeeperMapper.new(
          input.slice(:hair, :bodytype, :species),
          input.slice(:name, :email, :phone, :county),
          input[:location]
        )

        input = [keeper_mapper, input[:file], input[:distance], input[:searchcounty], input[:county]]

        Success(input)
      rescue StandardError => e
        Failure(e.message)
      end

      def setting_keeper_info(input)
        keeper_mapper = input[0]
        keeper_mapper.images_url(input[1])
        keeper_mapper.image_recoginition
        keeper_mapper.store_user_info
        puts 'set keeper mapper'
        input = [keeper_mapper, input[2], input[3], input[4]]
        Success(input:)
      rescue StandardError => e
        Failure(Response::ApiResult.new(status: :internal_error, message: e.message))
      end

      def create_keeper_info(input) # rubocop:disable Metrics/AbcSize
        keeper_mapper = input[:input][0]

        keeper = keeper_mapper.build_entity(input[:input][1], input[:input][2], input[:input][3])

        if keeper.lossing_animals_list.empty?
          return Failure(Response::ApiResult.new(status: :no_content, message: 'no animal found'))

        end

        binding.pry
        res = Response::FinderInfo.new(finders: keeper.lossing_animals_list)
          .then { Representer::VetRecommeandation.new(_1) }
          .then(&:to_json)

        Messaging::Queue.new(App.config.STAYTIME_QUEUE_URL, App.config).send(res)

        Success(Response::ApiResult.new(status: :processing, message: 'processing your request'))

        # Success(Response::ApiResult.new(status: :ok, message: res))
      rescue StandardError
        Failure(Response::ApiResult.new(status: :bad_request, message: 'Cannot find any lost animal nearby'))
      end
    end
  end
end
