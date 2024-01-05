# frozen_string_literal: true

require 'roda'
require 'slim'
require 'slim/include'
require 'json'
require 'uri'
require 'open3'

module PetAdoption
  # for controller part

  # rubocop:disable Metrics/ClassLength
  class App < Roda
    plugin :halt
    plugin :all_verbs # allows HTTP verbs beyond GET/POST (e.g., DELETE)

    plugin :json

    # use Rack::MethodOverride

    route do |routing|
      response['Content-Type'] = 'application/json'

      # GET /
      routing.root do
        message = "PetAdoption API v1 at /api/v1/ in #{App.environment} mode"

        result_response = Representer::HttpResponse.new(
          Response::ApiResult.new(status: :ok, message:)
        )

        response.status = result_response.http_status_code
        result_response.to_json
      end

      # ok
      routing.on 'api/v1' do
        routing.on 'shelters' do
          routing.on 'crowdedness' do
            routing.on String do |shelter_name|
              routing.get do
                shelter_name = Request::ShelterCrowdedness.new(shelter_name)

                crawded_ratio = Services::ShelterCapacityCounter.new.call({ shelter_name: })
                if crawded_ratio.failure?
                  failed = Representer::HttpResponse.new(crawded_ratio.failure)
                  routing.halt failed.http_status_code, failed.to_json
                end

                http_response = Representer::HttpResponse.new(crawded_ratio.value!)
                response.status = http_response.http_status_code

                Representer::ShelterCrowdedness.new(
                  crawded_ratio.value!.message
                ).to_json
              end
            end
          end

          # ok
          routing.on 'oldanimals' do
            routing.on String do |shelter_name|
              routing.get do
                shelter_name = Request::ShelterCrowdedness.new(shelter_name)

                severity = Services::ExtentOfTooManyOldAnimals.new.call({ shelter_name: })
                if severity.failure?
                  failed = Representer::HttpResponse.new(severity.failure)
                  routing.halt failed.http_status_code, failed.to_json
                end

                http_response = Representer::HttpResponse.new(severity.value!)
                response.status = http_response.http_status_code

                Representer::ShelterTooOldAnimals.new(
                  severity.value!.message
                ).to_json
              end
            end
          end

          # ok
          routing.on String, String do |animal_kind, shelter_name|
            routing.get do
              animal_request = Request::AnimalLister.new(animal_kind, shelter_name)

              get_all_animals_in_shelter = Services::SelectAnimal.new.call({ animal_request: })

              if get_all_animals_in_shelter.failure?
                failed = Representer::HttpResponse.new(get_all_animals_in_shelter.failure)
                routing.halt failed.http_status_code, failed.to_json
              end

              http_response = Representer::HttpResponse.new(get_all_animals_in_shelter.value!)
              response.status = http_response.http_status_code

              Representer::ShelterAnimals.new(
                get_all_animals_in_shelter.value!.message
              ).to_json
            end
          end
        end

        # POST /api/v1/
        routing.on 'finder' do
          routing.on 'vets' do
            routing.post do
              request_body = routing.params

              request = Requests::VetRecommendation.new(request_body)
              # puts 'create request'

              res = Services::FinderUploadImages.new.call({ request: })

              if res.failure?
                failed = Representer::HttpResponse.new(res.failure)
                routing.halt failed.http_status_code, failed.to_json
              end

              # puts 'get the response'
              http_response = Representer::HttpResponse.new(res.value!)
              response.status = http_response.http_status_code
              Representer::VetRecommeandation.new(
                res.value!.message
              ).to_json
            end
          end
        end

        # ok
        routing.on 'user' do
          routing.on 'count-animal-score' do
            routing.post do
              score_request = Request::AnimalScore.new(routing.params)

              score_response = Services::PickAnimalByOriginID.new.call({ score_request: })
              if score_response.failure?
                failed = Representer::HttpResponse.new(score_response.failure)
                routing.halt failed.http_status_code, failed.to_json
              end

              http_response = Representer::HttpResponse.new(score_response.value!)
              response.status = http_response.http_status_code

              Representer::AnimalScore.new(
                score_response.value!.message
              ).to_json
            end
          end
        end

        # ok
        routing.on 'promote-user-animals' do
          routing.post do
            input = routing.params

            req = Request::PromoteUserAnimals.new(input)

            output = Services::PromoteUserAnimals.new.call({ req: })

            if output.failure?
              failed = Representer::HttpResponse.new(output.failure)
              routing.halt failed.http_status_code, failed.to_json
            end

            http_response = Representer::HttpResponse.new(output.value!)
            response.status = http_response.http_status_code

            Representer::AllAnimalRecommendation.new(
              output.value!.message
            ).to_json
          end
        end

        routing.on 'keeper' do
          routing.on 'contact' do
            routing.post do
              input = routing.params

              req = Request::KeeperContact.new(input)

              res = Services::KeeperUploadImages.new.call({ req: })

              if res.failure?
                failed = Representer::HttpResponse.new(res.failure)
                routing.halt failed.http_status_code, failed.to_json
              end

              http_response = Representer::HttpResponse.new(res.value!)
              response.status = http_response.http_status_code

              Representer::PotentialFinderRepresenter.new(
                res.value!.message
              ).to_json
            end
          end
        end
      end
    end
  end
  # rubocop:enable Metrics/ClassLength
end
