# frozen_string_literal: true

require_relative '../require_app'
require_relative 'maps_monitor'
require_app

require 'figaro'
require 'shoryuken'
require_relative 'job_reporter'
require 'json'
require 'pry'

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

    puts "worker, access_key_id: #{config.S3_Access_Key},
    secret_access_key: #{config.S3_Secret_Key},
    region: #{config.SQS_REGION}"

    include Shoryuken::Worker
    Shoryuken.sqs_client_receive_message_opts = { wait_time_seconds: 20 }
    shoryuken_options queue: config.QUEUE_1_URL, auto_delete: true
    puts "worker1, URL1: #{config.QUEUE_1_URL}"

    def perform(_sqs_msg, request)
      puts 'start the finder job'
      job = PetAdoptoion::Background::JobReporter.new(request, FinderWorker.config)
      job.report_each_second(1) { PetAdoption::MAPSMonitor.starting_percent }

      request = JSON.parse(request).transform_keys(&:to_sym)
      finder_mapper = finder_settings(request)

      job.report_each_second(10) { PetAdoption::MAPSMonitor.vets_recommendation_percent }
      data, err = finder_mapper.recommends_some_vets(request[:distance], request[:number])

      job.report_each_second(2) { PetAdoption::MAPSMonitor.finish_percent }
      puts 'finish the finder job'

      raise StandardError unless err.nil?

      PetAdoption::Cache::RedisCache.new(self.class.config).set('vets', data.to_json)
    rescue StandardError
      puts 'error: no vet nearby you'
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
