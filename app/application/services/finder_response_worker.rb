# frozen_string_literal: true

require 'dry/transaction'
require 'pry'

module PetAdoption
  module Services
    # class ImageRecognition`
    class FinderReport
      include Dry::Transaction
      step :check_data_prepared_in_redis

      private

      FAILMSG = 'data not yet prepared in redis'

      def check_data_prepared_in_redis
        # send to queue

        take_care_info, vet_check = cache_check_helper


        delete_elements_in_redis # delete elements in redis
        Success(Response::ApiResult.new(status: :ok, message: [take_care_info, vet_check]))
      rescue StandardError
        Failure(Response::ApiResult.new(status: :internal_error, message: 'system error'))
      end

      # helper function for cache data check
      def cache_check_helper
        # polling from redis
        cache = PetAdoption::Cache::RedisCache.new(App.config)
        sleep(1) while cache.get('take_care_info').nil? || cache.get('vets').nil?
        [cache.get('take_care_info'), cache.get('vets')]
      end

      def delete_elements_in_redis
        cache = PetAdoption::Cache::RedisCache.new(App.config)
        cache.del('take_care_info')
        cache.del('vets')
      end

      # def response(take_care_info, vet_check)
      #   binding.pry
      #   # PetAdoption::Representer::VetRecommeandation.new(
      #   #   PetAdoption::Response::ClinicRecommendation.new
      #   # ).from_json(take_care_info, vet_check)
      #   vet_check = JSON.parse(vet_check)
      #   vet_check.map! do |vet|
      #     vet.transform_keys(&:to_sym)
      #   end
      #   take_care_info = JSON.parse(take_care_info)
      #   PetAdoption::Representer::VetRecommeandation.new(
      #     Response::ClinicRecommendation.new(clinics: vet_check, take_care_info:)
      #   ).to_json
      # end
    end
  end
end
