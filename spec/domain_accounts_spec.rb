# frozen_string_literal: true

require_relative 'spec_helper'
require_relative 'helpers/vcr_helper'
# require_relative 'helpers/database_helper'
require_relative '../app/controllers/app'
require 'securerandom'
require 'json'
require 'pry'

describe 'Check the content of the cookie written to db is same as the file' do
  before do
    # data = File.read('spec/testing_cookies/user_input.json')
    # data = JSON.parse(data)
  end

  it 'HAPPY: should get the same item in the files and cookies' do
    # read the cookie from the file that is created from one-time browsing
    # broweser_cookie = File.read('spec/testing_cookies/cookies.json')
    # get the cookie from the database
    # pet_cookie = PetAdoption::Repository::For.entity(gh_project).create(gh_project)

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

  # it 'HAPPY: should get accurate contributions summary for specific folder' do
  #   forms = CodePraise::Mapper::Contributions.new(@gitrepo).for_folder('forms')

  #   _(forms.subfolders.count).must_equal 1
  #   _(forms.subfolders.count).must_equal 1

  #   _(forms.base_files.count).must_equal 2

  #   count = forms['url_request.rb'].credit_share.by_email 'b37582000@gmail.com'
  #   _(count).must_equal 5

  #   count = forms['url_request.rb'].credit_share.by_email 'orange6318@hotmail.com'
  #   _(count).must_equal 2

  #   count = forms['init.rb'].credit_share.by_email 'b37582000@gmail.com'
  #   _(count).must_equal 4
  # end
end
