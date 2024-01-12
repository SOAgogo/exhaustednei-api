# frozen_string_literal: true

require 'figaro'
require 'roda'
require 'logger'
require 'rack/session'
require 'sequel'
require 'rack/cache'
require 'redis-rack-cache'
require 'pry'

module PetAdoption
  # Configuration for the App
  class App < Roda
    plugin :environments
    configure do # rubocop:disable Metrics/BlockLength
      # Environment variables setup
      Figaro.application = Figaro::Application.new(
        environment:,
        path: File.expand_path('config/secrets.yml')
      )
      Figaro.load
      def self.config = Figaro.env

      # for testing and development, use sqlite
      configure :development, :test do
        ENV['DATABASE_URL'] = "sqlite://#{config.DB_FILENAME}"
        use Rack::Cache,
            verbose: true,
            metastore: 'file:_cache/rack/meta',
            entitystore: 'file:_cache/rack/body'
      end

      configure :production do
        #ENV['DATABASE_URL'] = "sqlite://#{config.DB_FILENAME}"
        use Rack::Cache,
            verbose: true,
            metastore: "#{config.REDISCLOUD_URL}/0/metastore",
            entitystore: "#{config.REDISCLOUD_URL}/0/entitystore"
      end

      configure :test do
        ENV['testing'] = 'true'
        ENV['TESTING_FILE'] = config.TESTING_FILE.to_s
      end

      use Rack::Session::Cookie, {
        secret: config.SESSION_SECRET,
        expire_after: 60 * 60 * 24 * 7 # one week
      }
      # Database Setup
      @db = Sequel.connect(ENV.fetch('DATABASE_URL'))
      def self.db = @db # rubocop:disable Style/TrivialAccessors

      # @logger = Logger.new($stderr)
      @logger = Logger.new($stdout)
      class << self
        attr_reader :logger
      end
    end
  end
end
