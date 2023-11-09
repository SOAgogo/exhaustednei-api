# frozen_string_literal: true

require 'figaro'
require 'roda'
require 'figaro'
require 'roda'

require 'sequel'
require 'yaml'

require 'sequel'
require 'yaml'

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

      # Database Setup
      @db = Sequel.connect(ENV.fetch('DATABASE_URL'))
      def self.db = @db # rubocop:disable Style/TrivialAccessors
    end
  end
end