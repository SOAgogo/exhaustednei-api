# frozen_string_literal: true

module PetAdoption
  module Mixins
    # Mixin for calculating shelter capacity
    module ShelterCapacity
      def shelter_capacity(county_name) # rubocop:disable Metrics/AbcSize,Metrics/MethodLength,Metrics/CyclomaticComplexity
        case county_name # rubocop:disable Style/HashLikeCase
        when '臺北市'
          5066
        when '新北市'
          2085
        when '桃園市'
          4168
        when '臺中市'
          2709
        when '臺南市'
          3771
        when '高雄市'
          3590
        when '基隆市'
          268
        when '新竹市'
          433
        when '嘉義市'
          100
        when '新竹縣'
          424
        when '苗栗縣'
          2391
        when '彰化縣'
          1636
        when '南投縣'
          639
        when '雲林縣'
          158
        when '屏東縣'
          620
        when '宜蘭縣'
          1653
        when '花蓮縣'
          350
        when '臺東縣'
          586
        when '澎湖縣'
          730
        when '金門縣'
          455
        when '連江縣' # rubocop:disable Lint/DuplicateBranch
          100
        end
      end
    end
  end
end
