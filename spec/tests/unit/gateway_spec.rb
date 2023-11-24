# frozen_string_literal: true

# test the data coming from gateway api are the same as the data in the database
require_relative '../integration/spec_helper'
require_relative '../../helpers/vcr_helper'
require 'uri'
require 'json'

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
      params = {
        'UnitId' => 'QcbUEzN6E6DL',
        '$top' => 1
      }
      base_url = 'https://data.moa.gov.tw/Service/OpenData/TransService.aspx'
      # Append parameters to the URL
      url = URI.parse("#{base_url}?#{URI.encode_www_form(params)}")

      # Create an HTTP object
      http = Net::HTTP.new(url.host, url.port)
      http.use_ssl = (url.scheme == 'https')

      # Create a GET request
      request = Net::HTTP::Get.new(url)

      # Perform the request
      response = JSON.parse(http.request(request).body)[0]

      shelter = Repository::Info::Shelters.find_shelter_id(response['animal_shelter_pkid'])

      _(response['animal_shelter_pkid']).must_equal(shelter.animal_shelter_pkid)
      _(response['shelter_name']).must_equal(shelter.shelter_name)
      _(response['shelter_address']).must_equal(shelter.shelter_address)
      _(response['shelter_tel']).must_equal(shelter.shelter_tel)
    end
  end
end
