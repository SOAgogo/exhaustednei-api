# frozen_string_literal: true

require_relative 'test_helper'
require_relative '../../../../app/application/controllers/app'
require 'json'
require 'pry'

BASE_URL = PetAdoption::Storage::BASE_URL
BUCKET_NAME = PetAdoption::Storage::BUCKET_NAME
describe 'Check how many surronding animals' do
  # run testing=true bundle exec rake run first before running this test
  VCR.configure do |c|
    c.cassette_library_dir = CASSETTES_FOLDER
    c.hook_into :webmock
  end

  before do
    VCR.insert_cassette CASSETTE_FILE,
                        record: :new_episodes,
                        match_requests_on: %i[method uri headers]
  end

  after do
    VCR.eject_cassette
  end

  it 'HAPPY: should get the correct number of animals nearby you' do
    s3 = PetAdoption::Storage::S3.S3_init
    picture_obj_list = PetAdoption::Storage::S3.download_image_from_s3(s3)[1]
    animal_info = { hair: 'long', body_type: 'big', kind: 'dog' }
    s3_picture_url_list = picture_obj_list.map do |picture_obj|
      "#{BASE_URL}/#{picture_obj.key}"
    end
    user_info = { 'user_id' => '12345', 'user_name' => 'test_user', 'user_email' => '' }

    keeper_mapper = PetAdoption::LossingPets::KeeperMapper.new(s3_picture_url_list.sample, animal_info, user_info)
    keeper = keeper_mapper.build_entity(500, true)
    binding.pry
    keeper.how_many_similar_results.must_be_instance_of(Integer)
  end
end
