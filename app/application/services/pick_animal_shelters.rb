# frozen_string_literal: true

module PetAdoption
  module Services
    # class PickAnimalShelters`
    class PickAnimalShelters
      def initialize(cookie_hash)
        @cookie_hash = cookie_hash
      end

      def call
        animal = PetAdoption::Adopters::AnimalMapper.new(@cookie_hash).find
        Repository::Adopters::Animals.new(
          animal.to_attr_hash.merge(
            address: URI.decode_www_form_component(animal.address)
          )
        ).create_animal
      end
    end

    # class PickAnimalInfo`
    class PickAnimalCover
      def self.call
        Repository::Info::Animals.web_page_cover
      end
    end

    # class SelectAnimal`
    class SelectAnimal
      def self.call(animal_kind, shelter_name)
        Repository::Info::Animals.select_animal_by_shelter_name(animal_kind, shelter_name)
      end
    end
  end
end
