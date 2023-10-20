# frozen_string_literal: true

require 'simplecov'
SimpleCov.start

require 'json'
require 'minitest/autorun'
require 'minitest/unit' # minitest Github issue #17 requires
require 'minitest/rg'
require 'vcr'
require 'webmock'

require_relative '../lib/github_api'

json_file = File.read('spec/fixtures/DogCat_results.json')
CORRECT = JSON.parse(json_file)

CASSETTES_FOLDER = 'spec/fixtures/cassettes'
CASSETTE_FILE = 'animals-record'
