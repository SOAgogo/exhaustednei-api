# frozen_string_literal: true

module PetAdoption
  module Value
    # DonationCalculator
    class PetReview
      attr_reader :vet_info, :clinic_info

      def initialize(vet_info, top)
        @vet_info = give_average_rating(vet_info, top)
        @clinic_info = create_clnic
      end

      def open_now(vet_info)
        popular_vet = vet_info.select { |vet| vet[:open_time] }
        popular_vet = vet_info.select { |vet| vet[:total_ratings] >= 40 } if popular_vet.empty?
        popular_vet = popular_vet.select { |vet| vet[:total_ratings] >= 40 } unless popular_vet.empty?

        popular_vet
      end

      def give_average_rating(vet_info, top)
        average_ratings = vet_info.map { |vet| vet[:total_ratings] }.sum / vet_info.length if vet_info.length.positive?
        popular_vet = open_now(vet_info)
        [] if popular_vet.nil?
        # normalize the scores

        popular_vet.sort_by { |vet| vet[:rating] * vet[:total_ratings] / average_ratings }[0...top]
      end

      def create_clnic # rubocop:disable Metrics/MethodLength
        vet_info.map do |vet|
          Values::ClinicReview.new(
            name: vet[:name],
            open_time: vet[:open_time],
            which_road: vet[:which_road],
            address: vet[:address],
            longitude: vet[:longitude],
            latitude: vet[:latitude],
            rating: vet[:rating].to_f,
            total_ratings: vet[:total_ratings]
          )
        end
      end
    end
  end
end
