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

  describe 'HAPPY: should get the correct number of animals nearby you' do
    # fine
    before do
      @poster = PetAdoption::LossingPets::PosterMapper.new(
        { name: 'user1', user_email: 'y11212@gmail.com', phone_number: '08-7733626', county: '台北' }
      )
      @poster.upload_image('spec/test_s3_upload_image/labrador.png')
      @poster.store_user_info
    end

    # fine
    it 'should give posters some vets recommedations' do
      _(@poster.s3_images_url).must_equal('https://soapicture.s3.ap-northeast-2.amazonaws.com/uploadsspec/test_s3_upload_image/schooldog.jpg')
    end

    # fine
    it 'should store the posters info to DB and examine the stored data is correct' do
      poster_db = @keeper.users.find_user_info_by_image_url(@keeper.s3_images_url)
      _(poster_db[:name]).must_equal('user1')
      _(poster_db[:phone_number]).must_equal('08-7733626')
      _(poster_db[:user_email]).must_equal('y11212@gmail.com')
      _(poster_db[:county]).must_equal('台北')
    end

    it 'should get the take care suggestoions from gpt' do
      # picture_obj_list = PetAdoption::Storage::S3.download_image_from_s3(s3)[1]
      poster_entity = @poster.build_entity(300, 5)
      _(poster_entity.first_contact_vet).must_be :>, 0
      _(poster_entity.animals_take_care_suggestions).must_be_instance_of(String)
    end
  end
end
