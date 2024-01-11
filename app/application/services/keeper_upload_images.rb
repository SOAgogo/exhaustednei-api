# frozen_string_literal: true

require 'dry/transaction'
require 'pry'

module PetAdoption
  module Services
    # class ImageRecognition`
    class KeeperUploadImages
      include Dry::Transaction
      step :validate_input
      step :store_keeper_info
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

      def store_keeper_info(input)
        input = input.value!
        keeper_mapper = create_keeper_mapper(input)
        send_to_queue(input)
        input = [keeper_mapper, input[:distance], input[:searchcounty], input[:county]]
        Success(input)
      rescue StandardError => e
        Failure(e.message)
      end

      def create_keeper_info(input)
        keeper_mapper = input[0]

        # [1]: distance,  [2]: according_to_your_county, [3]: county
        # 1. At the same time, do build_entity and image_recoginition
        # 2. store_user_info

        keeper = keeper_mapper.build_entity(input[1], input[2], input[3])

        if keeper.lossing_animals_list.empty?
          return Failure(Response::ApiResult.new(status: :no_content, message: 'no animal found'))
        end

        res = Response::FinderInfo.new(keeper.lossing_animals_list)
        Success(Response::ApiResult.new(status: :processing, message: res))
      rescue StandardError
        Failure(Response::ApiResult.new(status: :bad_request, message: 'Cannot find any lost animal nearby'))
      end

      def create_keeper_mapper(input)
        PetAdoption::LossingPets::KeeperMapper.new(
          input.slice(:hair, :bodytype, :species),
          input.slice(:name, :email, :phone, :county),
          input[:location]
        )
      end

      def send_to_queue(request)
        queue = App.config.QUEUE_4_URL

        Messaging::Queue.new(queue, App.config).send(request.to_json)
      end
    end
  end
end
