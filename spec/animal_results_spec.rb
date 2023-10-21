# frozen_string_literal: true

require_relative 'spec_helper'
require 'pry'

describe 'Tests Animal API ' do
  VCR.configure do |c|
    c.cassette_library_dir = CASSETTES_FOLDER
    c.hook_into :webmock
    # c.filter_sensitive_data('<GITHUB_TOKEN>') { GITHUB_TOKEN }
    # c.filter_sensitive_data('<GITHUB_TOKEN_ESC>') { CGI.escape(GITHUB_TOKEN) }
  end

  before do
    VCR.insert_cassette CASSETTE_FILE,
                        record: :new_episodes,
                        match_requests_on: %i[method uri headers]
  end

  after do
    VCR.eject_cassette
  end

  describe 'Shelter information' do
    before do
      # update the DogCat_results every single day when do this tests
      @project = Info::Project.new(RESOURCE_PATH)
      # @project = Info::Project.new
      # @project.request_body = Info::Project.connection(RESOURCE_PATH)
      @project.connection
      @project.shelter_list = @project.initiate_shelterlist
      # binding.pry
    end
    it 'HAPPY: should connect to api successfully' do
      _(@project.request_body[0].keys).must_equal CORRECT[0].keys
      # _(project.git_url).must_equal CORRECT['git_url']
    end
    it 'HAPPY: should provide the same fields as same as the ones in CORRECT DATA' do
      # @project.conection
      _(@project.shelter_list.howmanyshelters).must_equal 6
      # _(project.git_url).must_equal CORRECT['git_url']
    end
    it 'HAPPY: should provide correct dog numbers in all shelters' do
      dog_number = @project.shelter_list.calculate_dog_cat_nums
      _(dog_number).must_equal 10
      # _(project.git_url).must_equal CORRECT['git_url']
    end
    # it 'HAPPY: should provide correct cat numbers' do
    #   cat_number = Info::Shelter.shelter.get_cat_number
    #   _(@project).must_equal CORRECT['size']
    #   # _(project.git_url).must_equal CORRECT['git_url']
    # end

    # it 'SAD: should raise exception on incorrect url' do
    #   path = "#{RESOURCE_PATH}error_here"
    #   project = Info::Project.new(path)
    #   _(proc do
    #       project.connection
    #     end).must_raise CodePraise::GithubApi::Response::NotFound
    # end

    # it 'SAD: should be wrong when existing some field is not correct ' do
    #   _(proc do
    #     CodePraise::GithubApi.new('BAD_TOKEN').project('soumyaray', 'foobar')
    #   end).must_raise CodePraise::GithubApi::Response::Unauthorized
    # end
  end

  # describe 'Animal information' do
  #   before do
  #     @project = CodePraise::GithubApi.new(GITHUB_TOKEN)
  #                                     .project(USERNAME, PROJECT_NAME)
  #   end

  #   it 'HAPPY: should recognize owner' do
  #     _(@project.owner).must_be_kind_of CodePraise::Contributor
  #   end

  #   it 'HAPPY: should identify owner' do
  #     _(@project.owner.username).wont_be_nil
  #     _(@project.owner.username).must_equal CORRECT['owner']['login']
  #   end

  #   it 'HAPPY: should identify contributors' do
  #     contributors = @project.contributors
  #     _(contributors.count).must_equal CORRECT['contributors'].count

  #     usernames = contributors.map(&:username)
  #     correct_usernames = CORRECT['contributors'].map { |c| c['login'] }
  #     _(usernames).must_equal correct_usernames
  #   end
  #   it 'Sad: Some field does not exist ' do
  #     contributors = @project.contributors
  #     _(contributors.count).must_equal CORRECT['contributors'].count

  #     usernames = contributors.map(&:username)
  #     correct_usernames = CORRECT['contributors'].map { |c| c['login'] }
  #     _(usernames).must_equal correct_usernames
  #   end
  # end
end
