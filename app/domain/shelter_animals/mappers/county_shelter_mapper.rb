# frozen_string_literal: true

require_relative '../entities/animals'

# create an animal object instance
module PetAdoption
  module Mapper
    # class Info::ShelterMapper`
    class CountyShelterMapper
      attr_reader :animal_info_list

      # use repository to get all the shelter info
      def initialize(animal_data_list)
        @animal_info_list = animal_data_list
      end

    end
  end
end
