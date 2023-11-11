# frozen_string_literal: true

require 'simplecov'
SimpleCov.start

require 'json'
require 'minitest/autorun'
require 'minitest/unit' # minitest Github issue #17 requires
require 'minitest/rg'
require 'vcr'
require 'webmock'

require_relative '../require_app'
require_app
DOWNLOAD_PATH = 'spec/fixtures/DogCat_results.json'
json_file = File.read(DOWNLOAD_PATH)
CORRECT = JSON.parse(json_file)[0..19]
RESOURCE_PATH = 'https://data.moa.gov.tw/Service/OpenData/TransService.aspx?UnitId=QcbUEzN6E6DL'
CASSETTES_FOLDER = 'spec/fixtures/cassettes'
CASSETTE_FILE = 'animals-record'
