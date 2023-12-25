# frozen_string_literal: true

require 'roda'
require 'slim'
require 'slim/include'
require 'json'
require 'uri'
require 'securerandom'
require 'fileutils'
require 'open3'
require 'pry'
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
      routing.on 'api/v1' do
        routing.on 'projects' do

          #curl localhost:9292/api/v1/projects/250831
          routing.on String do |animal_id|
            binding.pry

            routing.get do
              path_request = Request::AnimalRequest.new(
                animal_id
              )

              result = Services::SelectAnimal_by_ID.new.call(requested: path_request)
              if result.failure?
                failed = Representer::HttpResponse.new(result.failure)
                routing.halt failed.http_status_code, failed.to_json
              end
              http_response = Representer::HttpResponse.new(result.value!)
              response.status = http_response.http_status_code
              Representer::Animal.new(
                result.value!.message
              ).to_json
            end
          end
        end
        #curl localhost:9292/api/v1/animals/dog/宜蘭縣流浪動物中途之家
        routing.on 'animals' do
          routing.on String, String do |animal_kind, shelter_name|
            routing.get do
              path_request = Request::ShelterRequestList.new(
                shelter_name, animal_kind
              )
              result = Services::SelectAnimal.new.call(requested: path_request)
              if result.failure?
                failed = Representer::HttpResponse.new(result.failure)
                routing.halt failed.http_status_code, failed.to_json
              end
              http_response = Representer::HttpResponse.new(result.value!)
              response.status = http_response.http_status_code
              result.value!.message.keys.to_json
            end
          end
        end
      end
    end
    # rubocop:enable Metrics/BlockLength
  end
end