# PromoteUserAnimals
module PetAdoption
  module Services
    # class PromoteUserAnimals`
    class PromoteUserAnimals
      include Dry::Transaction

      step :get_all_shelters
      step :get_animals_in_county
      step :calculate_similarity

      def get_all_shelters(user_input)
        county = user_input[0]['county']
        shelters_in_county = if user_input[1]['searchcounty'] == 'yes'
                               Repository::Shelters.find_all_shelters_by_county(county)
                             else
                               Repository::Shelters.all
                             end
        user_input << { 'shelters_in_county' => shelters_in_county }

        Success(user_input:)
      end

      def get_animals_in_county(user_input)
        user_input = user_input[:user_input]
        shelters_in_county = user_input[2]['shelters_in_county']
        user_input[1].delete('searchcounty')

        animal_shelter = shelters_in_county.map do |shelter_name|
          Repository::Animals.select_animals_by_shelter(shelter_name)
        end

        user_input = user_input.reject.with_index { |_, index| index == 2 }
        user_input << animal_shelter[0]

        Success(user_input:)
      end

      def calculate_similarity(user_input)
        user_input = user_input[:user_input]
        binding.pry
        user_preference = user_input[0].transform_keys(&:to_sym)
        preference_ratio = user_input[1].transform_values(&:to_f).transform_keys(&:to_sym)
        preference_ratio.delete(:address)
        user_preference.delete(:county)

        user_preference[:sterilized] = user_preference[:sterilized] == 'yes'
        user_preference[:vaccinated] = user_preference[:vaccinated] == 'yes'

        animals = user_input[2]

        scores = animals.map do |_shelter_name, animal_obj|
          animal_obj.similarity_checking(user_preference, preference_ratio)
        end
        sorted_animals = animals.zip(scores)
        sorted_combined_list = sorted_animals.sort_by { |(_, _), score| -score }[0...preference_ratio[:top].to_i]

        binding.pry
        Success(user_info:, animal_shelter_info:)
      end
    end
  end
end
