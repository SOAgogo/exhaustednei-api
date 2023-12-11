# frozen_string_literal: true

require 'roda'
require 'slim'
require 'slim/include'
require 'json'
require 'uri'
require 'securerandom'
require 'fileutils'
require 'open3'

module PetAdoption
  # for controller part

  # rubocop:disable Metrics/ClassLength
  class App < Roda
    plugin :halt
    plugin :flash
    plugin :all_verbs

    # use Rack::MethodOverride

    route do |routing|
      response['Content-Type'] = 'application/json'


      # GET /
      routing.root do
        message = "exhaustednei API v1 at /api/v1/ in #{App.environment} mode"

        result_response = Representer::HttpResponse.new(
          Response::ApiResult.new(status: :ok, message:)
        )

        response.status = result_response.http_status_code
        result_response.to_json
      end
    end
    # rubocop:enable Metrics/BlockLength
  end
end