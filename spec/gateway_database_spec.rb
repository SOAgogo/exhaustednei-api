# frozen_string_literal: false

require_relative 'spec_helper'
require_relative 'helpers/vcr_helper'
require_relative 'helpers/database_helper'

describe 'Integration Tests of Github API and Database' do
  before do
    VcrHelper.setup_vcr
  end

  random = rand(0..19)
  rand_shelter_id = CORRECT[random]['animal_shelter_pkid']
  rand_animal_id = CORRECT[random]['animal_id']

  after do
    VcrHelper.eject_vcr
  end

  describe 'Retrieve and store project' do
    before do
      DatabaseHelper.wipe_database
      project = Info::Project.new(RESOURCE_PATH)
      animal_shelter_initator = Info::AnimalShelterInitiator.new(project)
      shelter_mapper, animal_mapper = animal_shelter_initator.init
      shelter_mapper.create_all_shelter_animal_obj(
        Info::AnimalMapper.shelter_animal_mapping(animal_mapper.animal_info_list)
      )
    end

    it 'HAPPY: should be able to save animal info from government website to database' do
      animal = Info::ShelterMapper.find_animal_in_shelter(rand_shelter_id, rand_animal_id)

      rebuilt = Info::Repository::For.entity(animal).create(animal)

      _(rebuilt.animal_id).must_equal(animal.animal_id)
      _(rebuilt.animal_kind).must_equal(animal.animal_kind)
      _(rebuilt.animal_variate).must_equal(animal.animal_variate)
      _(rebuilt.animal_sex).must_equal(animal.animal_sex)
      _(rebuilt.animal_sterilization).must_equal(animal.animal_sterilization)
      _(rebuilt.animal_place).must_equal(animal.animal_place)

      #   project.contributors.each do |member|
      #     found = rebuilt.contributors.find do |potential|
      #       potential.origin_id == member.origin_id
      #     end

      #     _(found.username).must_equal member.username
      #   end
    end

    it 'HAPPY: should be able to save shelter info from government website to database' do
      shelter = Info::ShelterMapper.get_shelter_obj(rand_shelter_id)

      rebuilt = Info::Repository::For.entity(shelter).create(shelter)

      _(rebuilt.animal_shelter_pkid).must_equal(shelter.animal_shelter_pkid)
      _(rebuilt.shelter_name).must_equal(shelter.shelter_name)
      _(rebuilt.shelter_address).must_equal(shelter.shelter_address)
      _(rebuilt.shelter_tel).must_equal(shelter.shelter_tel)
      _(rebuilt.cat_number).must_equal(shelter.cat_number)
      _(rebuilt.dog_number).must_equal(shelter.dog_number)
      _(rebuilt.animal_number).must_equal(shelter.animal_number)
    end
  end
end
