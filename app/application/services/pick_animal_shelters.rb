# frozen_string_literal: true

module PetAdoption
  module Services
    DB_ERR_MSG = 'Having trouble accessing the database'

    # class SelectAnimal`
    class SelectAnimal
      include Dry::Transaction

      step :validation
      step :select_animal

      private

      def validation(input)
        search_req = input[:animal_request].call
        if search_req.success?
          input[:animal_request].call
        else
          Failure(search_req.failure)
        end
      end

      def select_animal(input)
        animal_obj_list = PetAdoption::Repository::Animals
          .select_animal_by_shelter_name_kind(input[0], input[1])

        animal_obj_list = animal_obj_list.values.map do |animal_obj|
          Response::Animal.new(animal_obj.animalinfo)
        end
        animal_obj_list = Response::AnimalList.new(animal_obj_list)

        Success(Response::ApiResult.new(status: :ok, message: animal_obj_list))
      rescue StandardError => e
        App.logger.error("ERROR: #{e.inspect}")
        Failure(Response::ApiResult.new(status: :bad_request, message: DB_ERR_MSG))
      end
    end

    # class PickAnimalByOriginID`
    class PickAnimalByOriginID
      include Dry::Transaction

      step :validation
      step :select_animal
      step :create_animal
      step :calculate_similarity

      private

      def validation(input)
        score_request = input[:score_request].call
        if score_request.success?
          Success(score_request)
        else
          Failure(score_request.failure)
        end
      end

      def select_animal(input)
        request = input.value!
        animal_obj = PetAdoption::Repository::Animals
          .find_animal(request[0])

        input = [animal_obj, request[1], request[2]]
        Success(input:)
      rescue StandardError => e
        Failure(e.message)
      end

      def create_animal(input)
        animal_obj, creation_or_not = PetAdoption::Mapper::AnimalMapper.find(input[:input][0])
        Failure('your animal information cant be created') unless creation_or_not
        input = [animal_obj, input[:input][1], input[:input][2]]
        Success(input:) if creation_or_not
      rescue StandardError => e
        Failure(e.message)
      end

      def calculate_similarity(input)
        animal_obj = input[:input][0]
        score = animal_obj.similarity_checking(input[:input][1], input[:input][2])
        score_response = Response::AnimalScores.new(score)
        Success(Response::ApiResult.new(status: :ok, message: score_response))
      rescue StandardError => e
        Failure(e.message)
      end
    end

    # class ShelterCapacityCounter`
    class ShelterCapacityCounter
      include Dry::Transaction

      step :validation
      step :create_shelter
      step :calculate_capacity_ratio

      private

      def validation(input)
        shelter_name = input[:shelter_name].call
        if shelter_name.success?
          Success(shelter_name)
        else
          Failure(shelter_name.failure)
        end
      end

      def create_shelter(input)
        shelter_obj = Repository::Shelters.find_shelter_by_name(input.value!)
        if shelter_obj
          Success(shelter_obj:)
        else
          Failure(Response::ApiResult.new(status: :not_found, message: DB_ERR_MSG))
        end
      rescue StandardError => e
        App.logger.error("ERROR: #{e.inspect}")
        Failure(Response::ApiResult.new(status: :internal_error, message: DB_ERR_MSG))
      end

      def calculate_capacity_ratio(input)
        capacity_ratio = input[:shelter_obj].capacity_ratio
        metric = Response::Metrics.new(capacity_ratio)

        Success(Response::ApiResult.new(status: :ok, message: metric))
      rescue StandardError => e
        App.logger.error("ERROR: #{e.inspect}")
        Failure(Response::ApiResult.new(status: :internal_error, message: DB_ERR_MSG))
      end
    end

    # class ExtentOfTooManyOldAnimals`
    class ExtentOfTooManyOldAnimals
      include Dry::Transaction

      step :validation
      step :create_shelter
      step :calculate_severity

      private

      def validation(input)
        shelter_name = input[:shelter_name].call
        if shelter_name.success?
          Success(shelter_name)
        else
          Failure(shelter_name.failure)
        end
      end

      def create_shelter(input)
        shelter_obj = Repository::Shelters.find_shelter_by_name(input.value!)

        Success(shelter_obj:)
      rescue StandardError => e
        App.logger.error("ERROR: #{e.inspect}")
        Failure(Response::ApiResult.new(status: :internal_error, message: DB_ERR_MSG))
      end

      def calculate_severity(input)
        old_animal_num = input[:shelter_obj].shelter_stats.stay_too_long_animals
        severity = input[:shelter_obj].shelter_stats.severity_of_old_animals
        severity = Response::Severity.new(old_animal_num, severity)
        Success(Response::ApiResult.new(status: :ok, message: severity))
      rescue StandardError => e
        Failure(Response::ApiResult.new(status: :not_found, message: e.to_s))
      end
    end
  end
end
