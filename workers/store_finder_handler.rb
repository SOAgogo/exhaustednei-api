# frozen_string_literal: true

require_relative '../require_app'
require_relative 'job_reporter'
require_relative 'gpt_monitor'
require_app
require 'figaro'
require 'shoryuken'
require 'json'
module Background
  # Background worker does image recognition
  class StorefinderWorker
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

    puts "worker3, access_key_id: #{config.S3_Access_Key},
    secret_access_key: #{config.S3_Secret_Key},
    region: #{config.SQS_REGION}"

    include Shoryuken::Worker
    Shoryuken.sqs_client_receive_message_opts = { wait_time_seconds: 20 }
    shoryuken_options queue: config.QUEUE_3_URL, auto_delete: true
    puts "worker3, URL3: #{config.QUEUE_3_URL}"

    def perform(_sqs_msg, request)
      # job = PetAdoptoion::Background::JobReporter.new(request, self.class.config)
      job = PetAdoptoion::Background::JobReporter.new(request, StorefinderWorker.config)
      job.report_each_second(1) { GPTMonitor.starting_percent }
      request = JSON.parse(request).transform_keys(&:to_sym)
      finder_mapper = create_finder_mapper(request, request[:file])
      job.report_each_second(8) { GPTMonitor.image_processing_percent }
      find_your_vets(finder_mapper)
      job.report_each_second(2) { GPTMonitor.finish_percent }
    rescue StandardError
      puts 'ImageRecognition EXISTS -- ignoring request'
    end

    private

    def create_finder_mapper(request, image_url)
      finder_mapper = PetAdoption::LossingPets::FinderMapper.new(
        request.slice(:name, :email, :phone, :county),
        request[:location]
      )
      finder_mapper.images_url(image_url)
      finder_mapper
    end

    def find_your_vets(finder_mapper)
      finder_mapper.image_recoginition
      finder_mapper.store_user_info
    end
  end
end
