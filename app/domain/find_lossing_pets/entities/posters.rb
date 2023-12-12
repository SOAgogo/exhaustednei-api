# frozen_string_literal: true

require 'dry-types'
require 'dry-struct'

module PetAdoption
  module Entity
    # class Info::adotpers`
    class Posters
      attr_reader :animal_pic, :animal_loc, :poster_info

      def initialize(animal_pic, animal_loc, poster_info)
        @animal_pic = animal_pic
        @animal_loc = animal_loc
        @poster_info = PetAdoption::Values::PosterInfo.new(poster_info)
      end
    end
  end
end
