# frozen_string_literal: true

module PetAdoption
  module Services
    # class PickAnimalInfo`
    class PickAnimalCover
      include Dry::Transaction

      step :pick_animal_cover

      def pick_animal_cover
        cover = Repository::Animals.web_page_cover
        Success(cover:)
      rescue StandardError => e
        Failure(e.message)
      end
    end

    # class SelectAnimal`
    class SelectAnimal
      include Dry::Transaction

      step :select_animal

      private

      def select_animal(input)
        animal_obj_list = PetAdoption::Repository::Animals
          .select_animal_by_shelter_name_kind(input[:animal_kind],
                                              input[:shelter_name])

        animal_obj_list = animal_obj_list.values
        Success(animal_obj_list:)
      rescue StandardError => e
        Failure(e.message)
      end
    end

    # class PickAnimalByOriginID`
    class PickAnimalByOriginID
      include Dry::Transaction

      step :select_animal
      step :create_animal
      step :calculate_similarity

      private

      def select_animal(input)
        animal_obj = PetAdoption::Repository::Animals
          .find_animal(input[:input][0])

        input = [animal_obj, input[:input][1], input[:input][2]]
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
        score = animal_obj.similarity_checking(input[:input][1], input[:input][2][0])
        Success(score:)
      rescue StandardError => e
        Failure(e.message)
      end
    end

    # class ShelterCapacityCounter`
    class ShelterCapacityCounter
      include Dry::Transaction

      step :create_shelter
      step :calculate_capacity_ratio

      private

      def create_shelter(input)
        shelter_obj = Repository::Shelters.find_shelter_by_name(input[:shelter_name])

        Success(shelter_obj:)
      rescue StandardError => e
        Failure(e.message)
      end

      def calculate_capacity_ratio(input)
        capacity_ratio = input[:shelter_obj].capacity_ratio
        old_animal_num = input[:shelter_obj].shelter_stats.stay_too_long_animals
        severity = input[:shelter_obj].shelter_stats.severity_of_old_animals
        output = [capacity_ratio, old_animal_num, severity]
        Success(output:)
      rescue StandardError => e
        Failure(e.message)
      end
    end
  end
end
