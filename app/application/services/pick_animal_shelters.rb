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
      step :decode_chinese_words

      private

      def select_animal(input)
        animal_obj_list = PetAdoption::Repository::Animals
          .select_animal_by_shelter_name_kind(input[:animal_kind],
                                         input[:shelter_name])

        Success(animal_obj_list:)
      rescue StandardError => e
        Failure(e.message)
      end

      def decode_chinese_words(input)
        animal_obj_list = PetAdoption::Views::ChineseWordsCanBeEncoded.to_decode_hash(input[:animal_obj_list])
        Success(animal_obj_list:)
      rescue StandardError => e
        Failure(e.message)
      end
    end
  end
end
