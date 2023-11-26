# frozen_string_literal: true

require 'pry'
module PetAdoption
  module Services
    # class PickAnimalShelters`
    # class PickAnimalShelters
    #   def initialize(cookie_hash)
    #     @cookie_hash = cookie_hash
    #   end

    #   def call
    #     animal = PetAdoption::Adopters::AnimalMapper.new(@cookie_hash).find
    #     Repository::Adopters::Animals.new(
    #       animal.to_attr_hash.merge(
    #         address: URI.decode_www_form_component(animal.address)
    #       )
    #     ).create_animal
    #   end
    # end

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
          .select_animal_by_shelter_name(input[:animal_kind],
                                         input[:shelter_name])
        Success(animal_obj_list:)
      rescue StandardError => e
        Failure(e.message)
      end
    end
  end
end
