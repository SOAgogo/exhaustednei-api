# frozen_string_literal: true

require_relative '../entities/country_shelters_info'
module PetAdoption
  # Maps over local and remote git repo infrastructure
  module ShelterInfo
    # CountryShelterMapper
    class CountryShelterMapper
      def self.all_the_counties
        %w[臺北市 新北市 桃園市 臺中市 臺南市 高雄市 基隆市 新竹市 嘉義市 新竹縣 苗栗縣 彰化縣 南投縣 雲林縣 嘉義縣 屏東縣 宜蘭縣 花蓮縣 臺東縣 澎湖縣 金門縣 連江縣]
      end

      def self.build_entity
        country_info = {}
        all_the_counties.map do |county|
          country_info[county] = PetAdoption::ShelterInfo::CountyShelterMapper.new(county).build_entity
        end
        Entity::CountryShelterStats.new(country_info)
      end
    end
  end
end
