# frozen_string_literal: true
require 'pry'
module PetAdoption
  module Services
    # class PickAnimalInfo`
    class PickAnimalCover
      include Dry::Transaction

      step :pick_animal_cover

      def pick_animal_cover
        cover = Repository::Info::Animals.web_page_cover
        Success(cover:)
      rescue StandardError => e
        Failure(e.message)
      end
    end

    # class SelectAnimal`
    class SelectAnimal
      include Dry::Transaction

      step :select_animal
      
      def select_animal(input)

        animal_obj_list = Repository::Info::Animals
          .select_animal_by_shelter_name(input[:requested].animal_kind,
                                        input[:requested].shelter_name)
                       
        Success(Response::ApiResult.new(status: :ok, message: animal_obj_list))
      rescue StandardError => e
        Failure(Response::ApiResult.new(status: :not_found, message: e.to_s))

      end
    end

    class SelectAnimal_by_ID
      include Dry::Transaction
      step :select_animal_by_ID
      def select_animal_by_ID(input)
        animal_obj_list = Repository::Info::Animals
          .find_animal_db_obj_by_id(input[:requested].animal_id)
                                        
        Success(Response::ApiResult.new(status: :ok, message: animal_obj_list))
      rescue StandardError => e
        Failure(Response::ApiResult.new(status: :not_found, message: e.to_s))

      end
    end
  end
end
