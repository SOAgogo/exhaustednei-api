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

      def create_keeper_mapper(input)
        keeper_mapper = PetAdoption::LossingPets::KeeperMapper.new(
          input[:keeper_info].slice(:hair, :bodytype, :species),
          input[:keeper_info].slice(:name, :email, :phone, :county),
          input[:keeper_info][:location]
        )
        input = [keeper_mapper, input[:keeper_info][:file], input[:keeper_info][:distance],
                 input[:keeper_info][:searchcounty]]
        Success(input:)
      rescue StandardError => e
        Failure(e.message)
      end

      def upload_image(input)
        keeper_mapper = input[:input][0]
        keeper_mapper.upload_image(input[:input][1])
        input = [keeper_mapper, input[:input][2], input[:input][3]]
        Success(input:)
      rescue StandardError => e
        Failure(e.message)
      end

      def store_upload_record(input)
        keeper_mapper = input[:input][0]
        keeper_mapper.store_user_info
        input = [keeper_mapper, input[:input][1], input[:input][2]]
        Success(input:)
      rescue StandardError => e
        Failure(e.message)
      end

      def create_keeper_info(input)
        keeper_mapper = input[:input][0]
        keeper = keeper_mapper.build_entity(input[:input][1], input[:input][2])

        if keeper.lossing_animals_list.empty?
          raise StandardError, 'Sorry, in this moment, there is no lossing pet nearby you'
        end

        Success(keeper:)
      end
    end
  end
end
