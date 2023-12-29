# frozen_string_literal: true

module PetAdoption
  module Value
    # DonationCalculator
    class PossibleLostAnimals
      def initialize(lost_animals_list)
        @lost_animals_list = lost_animals_list
      end

      def first_contact_vet
        # find the total_ratings of the vet is at least 50
        # normalized total_ratings by averaging the total_ratings
        average_ratings = @vet_info.map { |vet| vet[:total_ratings] }.sum / @vet_info.length
        popular_vet = @vet_info.select { |vet| vet[:total_ratings] >= 50 && vet[:open_time]['open_now'] }
        popular_vet = @vet_info.select { |vet| vet[:open_time]['open_now'] } if popular_vet.empty?
        popular_vet.max_by { |vet| vet[:rating] * vet[:total_ratings] / average_ratings }
      end
    end
  end
end
