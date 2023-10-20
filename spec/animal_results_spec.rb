# frozen_string_literal: true

require_relative 'spec_helper'

describe 'Tests Animal API ' do
  VCR.configure do |c|
    c.cassette_library_dir = CASSETTES_FOLDER
    c.hook_into :webmock
    #c.filter_sensitive_data('<GITHUB_TOKEN>') { GITHUB_TOKEN }
    #c.filter_sensitive_data('<GITHUB_TOKEN_ESC>') { CGI.escape(GITHUB_TOKEN) }
  end

  before do
    VCR.insert_cassette CASSETTE_FILE,
                        record: :new_episodes,
                        match_requests_on: %i[method uri headers]
  end

  after do
    VCR.eject_cassette
  end

  describe 'Animal information' do
    it 'HAPPY: should provide correct animal attributes' do
      project = CodePraise::GithubApi.new(GITHUB_TOKEN)
                                     .project(USERNAME, PROJECT_NAME)
      _(project.size).must_equal CORRECT['size']
      _(project.git_url).must_equal CORRECT['git_url']
    end

    it 'SAD: should raise exception on incorrect project' do
      _(proc do
        CodePraise::GithubApi.new(GITHUB_TOKEN).project('soumyaray', 'foobar')
      end).must_raise CodePraise::GithubApi::Response::NotFound
    end

    it 'SAD: should raise exception when unauthorized' do
      _(proc do
        CodePraise::GithubApi.new('BAD_TOKEN').project('soumyaray', 'foobar')
      end).must_raise CodePraise::GithubApi::Response::Unauthorized
    end
  end

  describe 'Shelter information' do
    before do
      @project = CodePraise::GithubApi.new(GITHUB_TOKEN)
                                      .project(USERNAME, PROJECT_NAME)
    end

    it 'HAPPY: should recognize owner' do
      _(@project.owner).must_be_kind_of CodePraise::Contributor
    end

    it 'HAPPY: should identify owner' do
      _(@project.owner.username).wont_be_nil
      _(@project.owner.username).must_equal CORRECT['owner']['login']
    end

    it 'HAPPY: should identify contributors' do
      contributors = @project.contributors
      _(contributors.count).must_equal CORRECT['contributors'].count

      usernames = contributors.map(&:username)
      correct_usernames = CORRECT['contributors'].map { |c| c['login'] }
      _(usernames).must_equal correct_usernames
    end
  end
end