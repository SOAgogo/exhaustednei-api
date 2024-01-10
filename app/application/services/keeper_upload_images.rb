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
      step :request_gpttext_worker


      private

      def validate_input(input)
        # puts 'validate_input'
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

        # puts 'create keeper mapper'
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
          return Failure(Response::ApiResult.new(status: :no_content,
                                                 message: 'no animal found'))
        end

        # puts 'create keeper info'
        res = Response::FinderInfo.new(keeper.lossing_animals_list)

        Success(Response::ApiResult.new(status: :ok, message: res))
      rescue StandardError
        Failure(Response::ApiResult.new(status: :bad_request, message: 'Cannot find any lost animal nearby'))
      end



      def request_gpttext_worker(input)
        puts 'generate gpt text, request_gpttext_worker'

        Messaging::Queue.new(Api.config.CLONE_QUEUE_URL, Api.config)
          .send(clone_request_json(input))
        Failure(
          Value::Result.new(status: :processing,
                    message: { request_id: input[:request_id] })
        )
      rescue StandardError => error
        puts [error.inspect, error.backtrace].flatten.join("\n")
        Failure(Value::Result.new(status: :internal_error, message: CLONE_ERR))
      end

    end
  end
end
