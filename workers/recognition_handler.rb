# frozen_string_literal: true

require_relative '../require_app'
require_relative 'gpt_monitor'
require_app

require 'figaro'
require 'shoryuken'
require_relative 'job_reporter'
require 'json'

module Background
  # Background worker does image recognition
  class RecognitionWorker
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

    puts "worker, access_key_id: #{config.S3_Access_Key},
    secret_access_key: #{config.S3_Secret_Key},
    region: #{config.SQS_REGION}"

    include Shoryuken::Worker
    Shoryuken.sqs_client_receive_message_opts = { wait_time_seconds: 20 }
    shoryuken_options queue: config.QUEUE_2_URL, auto_delete: true
    puts "worker2, URL2: #{config.QUEUE_2_URL}"

    def perform(_sqs_msg, request)
      puts 'recognition_handler.rb start'
      job = PetAdoptoion::Background::JobReporter.new(request, RecognitionWorker.config)
      job.report_each_second(1) { PetAdoption::GPTMonitor.starting_percent }
      request = JSON.parse(request).transform_keys(&:to_sym)
      finder_mapper = finder_settings(request)

      job.report_each_second(10) { PetAdoption::GPTMonitor.image_processing_percent }
      take_care_info = finder_mapper.give_some_take_care_pets_information
      job.report_each_second(2) { PetAdoption::GPTMonitor.finish_percent }
      PetAdoption::Cache::RedisCache.new(self.class.config).set('take_care_info', take_care_info.to_json)
      puts 'recognition_handler.rb end'
    rescue StandardError => e
      puts e.message
    end

    private

    def create_finder_mapper(request)
      PetAdoption::LossingPets::FinderMapper.new(
        request.slice(:name, :email, :phone, :county),
        request[:location]
      )
    end

    def finder_settings(request)
      finder_mapper = create_finder_mapper(request)
      finder_mapper.images_url(request[:file])
      finder_mapper
    end
  end
end
