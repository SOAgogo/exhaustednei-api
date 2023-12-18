# frozen_string_literal: true

require_relative 'test_helper'
require_relative '../../../../app/application/controllers/app'
require 'json'

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

  describe 'HAPPY: should get the correct number of animals nearby you' do
    # fine
    before do
      @keeper = PetAdoption::LossingPets::KeeperMapper.new(
        { hair: 'long', body_type: 'big', kind: 'dog' },
        { name: 'user2', user_email: 'ton@gmail.com', phone_number: '08-7488121' }
      )
      @keeper.upload_image('spec/test_s3_upload_image/schooldog.jpg')
      @keeper.store_user_info
    end

    # fine
    it 'should get the image public url from s3' do
      _(@keeper.s3_images_url).must_equal('https://soapicture.s3.ap-northeast-2.amazonaws.com/uploadsspec/test_s3_upload_image/margis3.jpeg')
    end

    # fine
    it 'should store the keeper info to DB and examine the stored data is correct' do
      keeper_db = @keeper.users.find_user_info_by_image_url(@keeper.s3_images_url)
      _(keeper_db[:name]).must_equal('user2')
      _(keeper_db[:phone_number]).must_equal('08-7488121')
      _(keeper_db[:user_email]).must_equal('ton@gmail.com')
    end

    # not yet
    it 'should get the correct number of animals nearby you' do
      # picture_obj_list = PetAdoption::Storage::S3.download_image_from_s3(s3)[1]
      keeper_entity = @keeper.build_entity(300, true)
      keeper_entity.how_many_similar_results.must_be_instance_of(Integer)
    end
  end
end
