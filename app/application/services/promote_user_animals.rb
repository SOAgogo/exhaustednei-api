# frozen_string_literal: true

require 'dry/transaction'
# PromoteUserAnimals
module PetAdoption
  module Services
    # class PromoteUserAnimals`
    class PromoteUserAnimals
      include Dry::Transaction

      step :validate_input
      step :get_all_shelters
      step :get_animals_in_county
      step :promote_to_user
      step :present_to_user

      def validate_input(input)
        request = input[:req].call
        request_value = request.value!
        if request_value[0][:age].nil? || request_value[0][:sterilized].nil? || request_value[0][:bodytype].nil?
          Failure('Please fill in the preference')
        end
        Success(request)
      end

      def get_all_shelters(user_input)
        input = user_input.value!
        shelters_in_county = Repository::Shelters.all_shelter_names

        input << { 'shelters_in_county' => shelters_in_county }
        Success(input:)
      rescue StandardError => e
        Failure(e.to_s)
      end

      def get_animals_in_county(user_input)
        user_input = user_input[:input]

        animal_shelter = user_input[3]['shelters_in_county'].map do |shelter_name|
          Repository::Animals.select_animals_by_shelter(shelter_name)
        end

        animal_shelter = animal_shelter.flatten(1)
        user_input = user_input.reject.with_index { |_, index| index == 3 }
        user_input << animal_shelter
        Success(user_input:)
      rescue StandardError => e
        Failure(e.to_s)
      end

      def promote_to_user(user_input)
        user_input = user_input[:user_input]

        scores = PromoteUserAnimals.calculate_similarity(user_input[3], user_input[0], user_input[1])

        sorted_animals = user_input[3].zip(scores)

        sorted_animals = PromoteUserAnimals.sort_the_order(sorted_animals, user_input[2])

        sorted_animals = PromoteUserAnimals.restructure_sorted_list(sorted_animals)

        Success(sorted_animals:)
      rescue StandardError => e
        Failure(e.to_s)
      end

      def present_to_user(user_input)
        sorted_animals = user_input[:sorted_animals]
        wrapper_list = PresenterWrapperList.new(sorted_animals)

        input = wrapper_list.recommendation.map do |wrapper|
          PromoteUserAnimals.create_response(wrapper)
        end

        res = Response::RecommendationScoresList.new(input)

        Success(Response::ApiResult.new(status: :ok, message: res))
      rescue StandardError => e
        Failure(e.to_s)
      end

      def self.calculate_similarity(animals, user_prference, ratio)
        animals.map do |animal_obj|
          animal_obj[1].similarity_checking(user_prference, ratio)
        end
      end

      def self.sort_the_order(sorted_animals, top)
        sorted_animals.sort_by { |(_, _), score| -score }[0...top]
      end

      def self.restructure_sorted_list(sorted_animals)
        sorted_animals.map do |shelter_data, score|
          {
            shelter_name: shelter_data[0],
            entity: shelter_data[1],
            score:
          }
        end
      end

      def self.create_response(wrapper)
        Response::RecommendationScores.new(
          wrapper.shelter_name,
          Response::Animal.new(wrapper.recommend_animal.animalinfo),
          Response::AnimalScores.new(wrapper.scores)
        )
      end
    end

    # class PresenterWrapper`
    class PresenterWrapper
      attr_reader :shelter_name, :recommend_animal, :scores

      def initialize(presenter)
        @shelter_name = presenter[:shelter_name]
        @recommend_animal = presenter[:entity]
        @scores = presenter[:score]
      end
    end

    # class PresenterWrapperList`
    class PresenterWrapperList
      attr_reader :recommendation

      def initialize(presenters)
        @recommendation = create_presenter_wrapper(presenters)
      end

      def create_presenter_wrapper(presenters)
        presenters.map do |presenter|
          PresenterWrapper.new(presenter)
        end
      end
    end
  end
end
