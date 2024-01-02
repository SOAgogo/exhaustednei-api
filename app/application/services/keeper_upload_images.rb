# frozen_string_literal: true

require 'dry/transaction'

module PetAdoption
  module Services
    # class ImageRecognition`
    class KeeperUploadImages
      include Dry::Transaction
      step :create_keeper_mapper
      step :upload_image
      step :store_upload_record
      step :create_keeper_info

      private

      def create_keeper_mapper(input) # rubocop:disable Metrics/MethodLength
        input = input[:req].call.value!

        keeper_mapper = PetAdoption::LossingPets::KeeperMapper.new(
          input.slice(:hair, :bodytype, :species),
          input.slice(:name, :email, :phone, :county),
          input[:location]
        )
        input = [keeper_mapper, input[:file], input[:distance],
                 input[:searchcounty], input[:county]]
        Success(input:)
      rescue StandardError => e
        Failure(e.message)
      end

      def upload_image(input)
        keeper_mapper = input[:input][0]
        keeper_mapper.upload_image(input[:input][1])
        input = [keeper_mapper, input[:input][2], input[:input][3], input[:input][4]]
        Success(input:)
      rescue StandardError => e
        Failure(e.message)
      end

      def store_upload_record(input)
        keeper_mapper = input[:input][0]
        keeper_mapper.store_user_info
        input = [keeper_mapper, input[:input][1], input[:input][2], input[:input][3]]
        Success(input:)
      rescue StandardError => e
        Failure(e.message)
      end

      def create_keeper_info(input)
        keeper_mapper = input[:input][0]

        keeper = keeper_mapper.build_entity(input[:input][1], input[:input][2], input[:input][3])

        if keeper.lossing_animals_list.empty?
          raise StandardError, 'Sorry, in this moment, there is no lossing pet nearby you'
        end

        res = Response::FinderInfo.new(keeper.lossing_animals_list)

        Success(Response::ApiResult.new(status: :ok, message: res))
      end
    end
  end
end
