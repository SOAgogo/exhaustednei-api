# count severity of shelters
# frozen_string_literal: false

require_relative 'test_helper'
require_relative '../../../helpers/vcr_helper'
require_relative '../../../helpers/database_helper'

describe 'Integration Tests of ChatGPT API and Database' do
  VcrHelper.setup_vcr
  before do
    VcrHelper.configure_vcr_for_website
  end

  random = rand(0..19)
  rand_shelter_id = CORRECT[random]['animal_shelter_pkid']

  after do
    VcrHelper.eject_vcr
  end

  describe 'Retrieve and store project' do
    before do
      DatabaseHelper.wipe_database
      project = PetAdoption::Info::Project.new(RESOURCE_PATH)
      animal_shelter_initator = PetAdoption::Info::AnimalShelterInitiator.new(project)
      countyshelter_mapper, animal_mapper = animal_shelter_initator.init
      countyshelter_mapper.create_all_shelter_animal_obj(
        PetAdoption::Info::AnimalMapper.shelter_animal_mapping(animal_mapper.animal_info_list)
      )
    end

    it 'HAPPY: should be able to save shelter info from government website to database' do
      taiwan_counties = %w[基隆市 臺北市 新北市 桃園市 新竹市 新竹縣 苗栗縣 臺中市 彰化縣 南投縣 雲林縣 嘉義市 嘉義縣 臺南市 高雄市 屏東縣 宜蘭縣 花蓮縣 臺東縣 澎湖縣 金門縣 連江縣]
      random_county = taiwan_counties.sample
      shelter = countyshelter_mapper.get_shelter_obj(random_county)

      # test contyshelter
      rebuilt = Repository::Info::For.entity(shelter).create(shelter)

      _(rebuilt.animal_shelter_pkid).must_equal(shelter.animal_shelter_pkid)
      _(rebuilt.shelter_name).must_equal(shelter.shelter_name)
      _(rebuilt.shelter_address).must_equal(shelter.shelter_address)
      _(rebuilt.shelter_tel).must_equal(shelter.shelter_tel)
      _(rebuilt.cat_number).must_equal(shelter.cat_number)
      _(rebuilt.dog_number).must_equal(shelter.dog_number)
      _(rebuilt.animal_number).must_equal(shelter.animal_number)

      # shelter_obj = Repository::Info::Animals.select_animal_by_shelter_name('狗', '高雄市壽山動物保護教育園區')

      shelter.animal_object_list.each do |animal_id, animal_obj|
        found, err = rebuilt.animal_object_list[animal_id]

        assert_nil err

        _(found.animal_id).must_equal(animal_obj.animal_id)
        _(found.animal_kind).must_equal(animal_obj.animal_kind)
        _(found.animal_variate).must_equal(animal_obj.animal_variate)
        _(found.animal_sex).must_equal(animal_obj.animal_sex)
        _(found.animal_sterilization).must_equal(animal_obj.animal_sterilization)
        _(found.animal_bacterin).must_equal(animal_obj.animal_bacterin)
        _(found.animal_bodytype).must_equal(animal_obj.animal_bodytype)
        _(found.album_file).must_equal(animal_obj.album_file)
        _(found.animal_place).must_equal(animal_obj.animal_place)
        _(found.animal_opendate).must_equal(animal_obj.animal_opendate)
      end
    end
  end
end
