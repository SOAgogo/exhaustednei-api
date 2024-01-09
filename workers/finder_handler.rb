# frozen_string_literal: true

require_relative '../require_app'
require_app

require 'figaro'
require 'shoryuken'

module Background
  # Background worker does image recognition
  class FinderWorker
    # Environment variables setup

    Figaro.application = Figaro::Application.new(
      environment: ENV['RACK_ENV'] || 'development',
      path: File.expand_path('config/secrets.yml')
    )
    Figaro.load
    def self.config = Figaro.env

    Shoryuken.sqs_client = Aws::SQS::Client.new(
      access_key_id: config.S3_Access_Key,
      secret_access_key: config.S3_Secret_Key,
      region: config.SQS_REGION
    )

    puts "worker, access_key_id: #{config.AWS_ACCESS_KEY_ID},
    secret_access_key: #{config.AWS_SECRET_ACCESS_KEY},
    region: #{config.AWS_REGION}"

    include Shoryuken::Worker
    Shoryuken.sqs_client_receive_message_opts = { wait_time_seconds: 20 }
    shoryuken_options queue: config.CLONE_QUEUE_URL, auto_delete: true
    puts "worker, URL1: #{config.CLONE_QUEUE_URL}"

    def perform(_sqs_msg, request)
      puts 'finder_handler.rb start'
      request = JSON.parse(request).transform_keys(&:to_sym)
      finder_mapper = create_finder_mapper(request)
      # finder = finder_settings(finder_mapper, request).build_entity(request[:distance], request[:number])
      finder_mapper = finder_settings(finder_mapper, request)

      represent(finder.vet_info.clinic_info, finder.take_care_info.instruction).to_json
    rescue StandardError => e
      puts e.message
    end

    private

    def represent(clinic_info, instruction)
      rsp = PetAdoption::Response::ClinicRecommendation.new(clinic_info, instruction)
      PetAdoption::Representer::VetRecommeandation.new(rsp)
    end

    # def report_failure(finder)
    #   return unless finder.vet_info.clinic_info.empty?

    #   Failure(Response::ApiResult.new(status: :no_content, message: 'there is no vet nearby you'))
    # end
    def create_finder_mapper(request)
      PetAdoption::LossingPets::FinderMapper.new(
        request.slice(:name, :email, :phone, :county),
        request[:location]
      )
    end

    def finder_settings(finder_mapper, request)
      finder_mapper.images_url(request[:file])
      finder_mapper.image_recoginition
      finder_mapper.store_user_info
      finder_mapper
    end
  end
end
