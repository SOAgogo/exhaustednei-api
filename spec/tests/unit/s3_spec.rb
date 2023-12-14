# frozen_string_literal: true

# test the data coming from gateway api are the same as the data in the database
require_relative '../../helpers/vcr_helper'
require 'uri'
require 'json'

describe 'Test Gpt API' do
  VcrHelper.setup_vcr

  before do
    VcrHelper.configure_vcr_for_website
  end

  after do
    VcrHelper.eject_vcr
  end

  describe 'Unit test of S3 upload image' do
    before do
      @s3 = PetAdoption::Storage::S3.S3_init
    end
    it 'HAPPY: should lists all images on S3' do
      picture_obj_list = PetAdoption::Storage::S3.download_image_from_s3(@s3)[1]
      _(picture_obj_list).must_be_instance_of(Aws::Xml::DefaultList)
    end
    it 'HAPPY: should upload image to S3' do
      res = PetAdoption::Storage::S3.upload_image_to_s3('spec/test_s3_upload_image/margis.jpeg')
      _(res).must_equal('File uploaded successfully to soapicture/uploadsspec/test_s3_upload_image/margis.jpeg')
    end
  end
end
