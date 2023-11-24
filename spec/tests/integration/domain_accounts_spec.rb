# frozen_string_literal: true

require_relative 'spec_helper'
require_relative '../../helpers/vcr_helper'
require_relative '../../../app/controllers/app'
require 'securerandom'
require 'json'

describe 'Check the content of the cookie written to db is same as the file' do
  # run testing=true bundle exec rake run first before running this test

  it 'HAPPY: should get the same item in the files and cookies' do
    data = File.read('spec/testing_cookies/user_input.json')
    data = JSON.parse(data)
    user_data = PetAdoption::Adopters::KeeperMapper.new(data).find
    save_user_data = Repository::Adopters::Users.new(user_data).create_user

    _(save_user_data.session_id).must_equal data['session_id']
    _(save_user_data.firstname).must_equal data['firstname']
    _(save_user_data.lastname).must_equal data['lastname']
    _(save_user_data.phone).must_equal data['phone']
    _(save_user_data.email).must_equal data['email']
    _(save_user_data.address).must_equal data['address']

    # compare the cookie from the file and the database
  end
end
