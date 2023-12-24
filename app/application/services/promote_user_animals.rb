module PetAdoption
  module Services
    # class PromoteUserAnimals`
    class PromoteUserAnimals
      include Dry::Transaction

      step :get_shelter_mapper
      step :get_animal_shelter_info
      step :promote_animals_to_user

      def get_shelter_mapper(user_input, user_preference)
        binding.pry
        user_info = user_input[:user_info]
        Success(user_info:)
      end

      def get_animal_shelter_info(user_input, user_preference)
        animal_shelter_info = user_input[:animal_shelter_info]
        Success(animal_shelter_info:)
      end

      def promote_animals_to_user(user_input, user_preference)
        user_info = user_input[:user_info]
        animal_shelter_info = user_input[:animal_shelter_info]
        Success(user_info:, animal_shelter_info:)
      end
    end
  end
end
