# frozen_string_literal: true

# test the data coming from gateway api are the same as the data in the database
require_relative '../integration/spec_helper'
require_relative '../../helpers/vcr_helper'
require 'uri'
require 'json'
require 'pry'

describe 'Test Animal API' do
  VcrHelper.setup_vcr

  before do
    VcrHelper.configure_vcr_for_website
  end

  after do
    VcrHelper.eject_vcr
  end

  describe 'Test API correctness' do
    it 'HAPPY: should provide the same fields as same as the ones in database' do
      params = { 'top' => 1 }
      url = URI.parse("#{RESOURCE_PATH}?#{URI.encode_www_form(params)}")
      http = Net::HTTP.new(url.host, url.port)
      http.use_ssl = true
      response = JSON.parse(PetAdoption::Info::Project.read_body(url, http))
      shelter = Repository::Info::Shelters.find_shelter_id(response[0]['animal_shelter_pkid'])

      # expected: return shelter object

      _(response.animal_shelter_pkid).must_equal(shelter.animal_shelter_pkid)
      _(response.shelter_name).must_equal(shelter.shelter_name)
      _(response.shelter_address).must_equal(shelter.shelter_address)
      _(response.shelter_tel).must_equal(shelter.shelter_tel)
      _(response.cat_number).must_equal(shelter.cat_number)
      _(response.dog_number).must_equal(shelter.dog_number)
      _(response.animal_number).must_equal(shelter.animal_number)
    end
  end
end
