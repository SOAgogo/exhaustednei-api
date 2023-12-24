# frozen_string_literal: true

require 'figaro'
require 'roda'
require 'logger'
require 'rack/session'
require 'sequel'

module PetAdoption
  # Configuration for the App
  class App < Roda
    plugin :environments
    configure do
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
      end

      configure :test do
        ENV['testing'] = 'true'
        ENV['TESTING_FILE'] = config.TESTING_FILE.to_s
      end

      use Rack::Session::Cookie, {
        secret: config.SESSION_SECRET,
<<<<<<< HEAD
        # expire_after: 60 * 60 * 24 * 730
        expire_after: 120
=======
        expire_after: 30
        # expire_after: 30
>>>>>>> exhaustednei/justin
      }
      # Database Setup
      @db = Sequel.connect(ENV.fetch('DATABASE_URL'))
      def self.db = @db # rubocop:disable Style/TrivialAccessors

      @logger = Logger.new($stderr)
      class << self
        attr_reader :logger
      end
    end
  end
end
