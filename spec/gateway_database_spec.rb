# frozen_string_literal: false

require_relative 'spec_helper'
require_relative 'helpers/vcr_helper'
require_relative 'helpers/database_helper'
require 'pry'

describe 'Integration Tests of Github API and Database' do
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
      project = Info::Project.new(RESOURCE_PATH)
      animal_shelter_initator = Info::AnimalShelterInitiator.new(project)
      shelter_mapper, animal_mapper = animal_shelter_initator.init
      shelter_mapper.create_all_shelter_animal_obj(
        Info::AnimalMapper.shelter_animal_mapping(animal_mapper.animal_info_list)
      )
    end

    it 'HAPPY: should be able to save shelter info from government website to database' do
      shelter = Info::ShelterMapper.get_shelter_obj(rand_shelter_id)

      
      rebuilt = Repository::Info::For.entity(shelter).create(shelter)

      _(rebuilt.animal_shelter_pkid).must_equal(shelter.animal_shelter_pkid)
      _(rebuilt.shelter_name).must_equal(shelter.shelter_name)
      _(rebuilt.shelter_address).must_equal(shelter.shelter_address)
      _(rebuilt.shelter_tel).must_equal(shelter.shelter_tel)
      _(rebuilt.cat_number).must_equal(shelter.cat_number)
      _(rebuilt.dog_number).must_equal(shelter.dog_number)
      _(rebuilt.animal_number).must_equal(shelter.animal_number)

      shelter.animal_object_list.each do |animal_id, animal_obj|
        found = rebuilt.animals.find do |animal|
          animal.animal_id == animal_id
        end
        _(found.animal_id).must_equal(animal_obj.animal_id)
      end
    end
  end
end
