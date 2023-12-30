# frozen_string_literal: true

module PetAdoption
  module Value
    # DonationCalculator
    class PetReview
      attr_reader :vet_info

      def initialize(vet_info, top)
        @vet_info = give_average_rating(vet_info, top)
      end

      def open_now(vet_info)
        popular_vet = vet_info.select { |vet| vet[:open_time]['open_now'] }
        popular_vet = popular_vet.select { |vet| vet[:total_ratings] >= 50 } if popular_vet.empty?
        popular_vet = vet_info.select { |vet| vet[:total_ratings] >= 50 } unless popular_vet.empty?

        popular_vet
      end

      def give_average_rating(vet_info, top)
        average_ratings = vet_info.map { |vet| vet[:total_ratings] }.sum / vet_info.length if vet_info.length.positive?
        popular_vet = open_now(vet_info)
        [] if popular_vet.nil?
        # normalize the scores

        popular_vet.sort_by { |vet| vet[:rating] * vet[:total_ratings] / average_ratings }[0...top]
      end
    end
  end
end
