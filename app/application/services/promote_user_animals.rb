# frozen_string_literal: true

require 'dry/transaction'
# PromoteUserAnimals
module PetAdoption
  module Services
    # class PromoteUserAnimals`
    class PromoteUserAnimals
      include Dry::Transaction

      step :get_all_shelters
      step :get_animals_in_county
      step :data_preprocessing
      step :promote_to_user

      def get_all_shelters(user_input)
        county = user_input[0]['county']
        if user_input[1]['searchcounty'] == 'yes'
          shelters_in_county = Repository::Shelters.find_all_shelters_by_county(county)
        end
        shelters_in_county = Repository::Shelters.all_shelter_names if user_input[1]['searchcounty'] == 'no'

        user_input << { 'shelters_in_county' => shelters_in_county }
        user_input[1].delete('searchcounty')
        Success(user_input:)
      rescue StandardError => e
        Failure(e.to_s)
      end

      def get_animals_in_county(user_input)
        user_input = user_input[:user_input]

        animal_shelter = user_input[2]['shelters_in_county'].map do |shelter_name|
          Repository::Animals.select_animals_by_shelter(shelter_name)
        end
        animal_shelter = animal_shelter.flatten(1)
        user_input = user_input.reject.with_index { |_, index| index == 2 }
        user_input << animal_shelter
        Success(user_input:)
      rescue StandardError => e
        Failure(e.to_s)
      end

      def data_preprocessing(user_input) # rubocop:disable Metrics/AbcSize
        user_input = user_input[:user_input]
        user_input[0] = user_input[0].transform_keys(&:to_sym)
        user_input[0].delete(:county)
        user_input[0][:sterilized] = user_input[0][:sterilized] == 'yes'
        user_input[0][:vaccinated] = user_input[0][:vaccinated] == 'yes'
        user_input[1] = user_input[1].transform_values(&:to_f).transform_keys(&:to_sym)
        user_input[1].delete(:address)
        Success(user_input:)
      rescue StandardError => e
        Failure(e.to_s)
      end

      def promote_to_user(user_input)
        user_input = user_input[:user_input]

        scores = PromoteUserAnimals.calculate_similarity(user_input[2], user_input[0], user_input[1])

        sorted_animals = user_input[2].zip(scores)
        sorted_animals = PromoteUserAnimals.sort_the_order(sorted_animals, user_input[1][:top].to_i)

        Success(sorted_animals:)
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
    end
  end
end
