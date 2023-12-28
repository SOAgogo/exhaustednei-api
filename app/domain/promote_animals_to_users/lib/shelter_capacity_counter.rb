# frozen_string_literal: true

module PetAdoption
  module Mixins
    # Mixin for calculating shelter capacity
    module ShelterCapacity
      def shelter_capacity(county_name) # rubocop:disable Metrics/AbcSize,Metrics/MethodLength,Metrics/CyclomaticComplexity
        case county_name # rubocop:disable Style/HashLikeCase
        when '臺北市'
          610
        when '新北市'
          1995
        when '桃園市'
          850
        when '臺中市'
          1000
        when '臺南市'
          760
        when '高雄市'
          950
        when '基隆市'
          150
        when '新竹市'
          400
        when '嘉義市'
          120
        when '新竹縣'
          174
        when '苗栗縣'
          355
        when '彰化縣'
          251
        when '南投縣'
          370
        when '雲林縣'
          300
        when '屏東縣'
          672
        when '宜蘭縣'
          330
        when '花蓮縣'
          350
        when '臺東縣'
          120
        when '澎湖縣'
          418
        when '金門縣'
          260
        when '連江縣' # rubocop:disable Lint/DuplicateBranch
          120
        end
      end
    end
  end
end
