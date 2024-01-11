# frozen_string_literal: true

require_relative '../require_app'
require_app

require 'figaro'
require 'shoryuken'

module Background
  # Background worker does image recognition
  class StorekeeperWorker
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

    puts "worker4, access_key_id: #{config.S3_Access_Key},
    secret_access_key: #{config.S3_Secret_Key},
    region: #{config.SQS_REGION}"

    include Shoryuken::Worker
    Shoryuken.sqs_client_receive_message_opts = { wait_time_seconds: 20 }
    shoryuken_options queue: config.QUEUE_4_URL, auto_delete: true
    puts "worker4, URL4: #{config.QUEUE_4_URL}"

    def perform(_sqs_msg, request)
      puts 'store_keeper_info.rb start'
      request = JSON.parse(request).transform_keys(&:to_sym)
      keeper_mapper = create_keeper_mapper(request)
      keeper_mapper.images_url(request[:file])
      keeper_mapper.image_recoginition
      keeper_mapper.store_user_info

      puts 'finish store_keeper_info.rb'
    rescue StandardError
      puts 'error: DB error '
    end

    private

    def create_keeper_mapper(request)
      PetAdoption::LossingPets::KeeperMapper.new(
        request.slice(:hair, :bodytype, :species),
        request.slice(:name, :email, :phone, :county),
        request[:location]
      )
    end
  end
end
