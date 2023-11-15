# frozen_string_literal: true

require_relative 'spec_helper'
require_relative 'helpers/vcr_helper'
# require_relative 'helpers/database_helper'
require_relative '../app/controllers/app'

describe 'Check the content of the cookie written to db is same as the file' do
  before do
    # how do I use rake run to type user data during the test?
    system('rake run')
  end

  it 'HAPPY: should get the same item in the files and cookies' do
    # read the cookie from the file that is created from one-time browsing
    broweser_cookie = File.read('spec/testing_cookies/cookies.json')
    # get the cookie from the database
    pet_cookie = PetAdoption::Repository::For.entity(gh_project).create(gh_project)
    # compare the cookie from the file and the database
  end

  it 'HAPPY: should get accurate contributions summary for specific folder' do
    forms = CodePraise::Mapper::Contributions.new(@gitrepo).for_folder('forms')

    _(forms.subfolders.count).must_equal 1
    _(forms.subfolders.count).must_equal 1

    _(forms.base_files.count).must_equal 2

    count = forms['url_request.rb'].credit_share.by_email 'b37582000@gmail.com'
    _(count).must_equal 5

    count = forms['url_request.rb'].credit_share.by_email 'orange6318@hotmail.com'
    _(count).must_equal 2

    count = forms['init.rb'].credit_share.by_email 'b37582000@gmail.com'
    _(count).must_equal 4
  end
end
