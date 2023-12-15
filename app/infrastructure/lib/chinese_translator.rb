# frozen_string_literal: true

module PetAdoption
  module ChineseTranslator
    # class Util`
    module Util
      def translate_county_to_chinese(english_county)
        county_translation = {
          'Taipei' => '臺北市',
          'New Taipei' => '新北市',
          'Keelung' => '基隆市',
          'Taichung' => '臺中市',
          'Tainan' => '臺南市',
          'Kaohsiung' => '高雄市',
          'Yilan' => '宜蘭縣',
          'Taoyuan' => '桃園市',
          'Hsinchu' => '新竹縣',
          'Miaoli' => '苗栗縣',
          'Changhua' => '彰化縣',
          'Nantou' => '南投縣',
          'Yunlin' => '雲林縣',
          'Chiayi' => '嘉義縣',
          'Pingtung' => '屏東縣',
          'Taitung' => '臺東縣',
          'Hualien' => '花蓮縣',
          'Penghu' => '澎湖縣',
          'Kinmen' => '金門縣',
          'Lienchiang' => '連江縣'
        }
        county_translation[english_county] || english_county
      end
    end
  end
end
