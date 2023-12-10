# frozen_string_literal: true

ENV['RACK_ENV'] ||= 'test'
require 'simplecov'
SimpleCov.start

require 'json'
require 'minitest/autorun'
require 'minitest/unit' # minitest Github issue #17 requires
require 'minitest/rg'
require 'vcr'
require 'webmock'

require_relative '../../require_app'
require_app

GPT_TOKEN = PetAdoption::App.config.GPT_TOKEN
RESOURCE_PATH = 'https://data.moa.gov.tw/Service/OpenData/TransService.aspx?UnitId=QcbUEzN6E6DL'
CASSETTES_FOLDER = 'spec/fixtures/cassettes'
CASSETTE_FILE = 'animals-record'
