# frozen_string_literal: true

module PetAdoption
  module Entity
    # class Sitters`
    class Sitters
      def initialize(take_care_information = String.new)
        @take_care_information = take_care_information
      end

      # tell chatgpt the health condition of the animal
      def ask_for_gpt_doctor(animals)
        animals.health_condition
      end

      def arrange_take_care_animal(take_care_animal)
        @take_care_animal = take_care_animal
      end
    end
  end
end
