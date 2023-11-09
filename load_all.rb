# frozen_string_literal: true

# run pry -r <path/to/this/file> to load entire application
require_relative 'config/environment' # load config info
require_relative 'spec/helpers/database_helper'
require_relative 'require_app'
require_app

def app = PetAdoption::App
