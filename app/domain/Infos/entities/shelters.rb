# frozen_string_literal: true

require 'dry-types'
require 'dry-struct'
require_relative '../../shelter_animals/entities/animal'

module PetAdoption
  module Entity
    # class Info::adotpers`
    class ShelterStats
      attr_reader :animal_no_sterilizations, :animal_sterilizations

      def initialize(animal_no_sterilizations:, animal_sterilizations:, animal_for_bacterin:, animal_for_no_bacterin:)
        @animal_no_sterilizations = animal_no_sterilizations
        @animal_sterilizations = animal_sterilizations
        @animal_for_bacterin = animal_for_bacterin
        @animal_for_no_bacterin = animal_for_no_bacterin
      end

      def count_num_sterilizations
        @animal_sterilizations.size
      end

      def count_num_no_sterilizations
        @animal_no_sterilizations.size
      end

      def count_num_animal_bacterin
        @animal_for_bacterin.size
      end

      def count_num_animal_no_bacterin
        @animal_for_no_bacterin.size
      end

      # def show_shelter_intro
      #   @shelter_stats['shelter_intro']
      # end
    end
  end
end
