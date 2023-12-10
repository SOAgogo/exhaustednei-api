# frozen_string_literal: true

module PetAdoption
  module StarSign
    # class Starsign`
    module Starsign
      def which_star_sign(birth_date) # rubocop:disable Metrics/AbcSize,Metrics/MethodLength,Metrics/PerceivedComplexity,Metrics/CyclomaticComplexity
        month = birth_date.month
        day = birth_date.day
        case month
        when 1
          day < 20 ? 'Capricorn' : 'Aquarius'
        when 2
          day < 19 ? 'Aquarius' : 'Pisces'
        when 3
          day < 21 ? 'Pisces' : 'Aries'
        when 4
          day < 20 ? 'Aries' : 'Taurus'
        when 5
          day < 21 ? 'Taurus' : 'Gemini'
        when 6
          day < 21 ? 'Gemini' : 'Cancer'
        when 7
          day < 23 ? 'Cancer' : 'Leo'
        when 8
          day < 23 ? 'Leo' : 'Virgo'
        when 9
          day < 23 ? 'Virgo' : 'Libra'
        when 10
          day < 23 ? 'Libra' : 'Scorpio'
        when 11
          day < 22 ? 'Scorpio' : 'Sagittarius'
        when 12
          day < 22 ? 'Sagittarius' : 'Capricorn'
        end
      end
    end
  end
end
