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
      @project.connection
      # @project.shelter_list = @project.initiate_shelterlist
      @project.initiate_shelterlist
      # binding.pry
    end

    ans = File.read('spec/fixtures/DogCat_results.json')
    shelter_id_ans = JSON.parse(ans).map{ |n| n["animal_shelter_pkid"]}.uniq.size
    num_dog_ans = JSON.parse(ans).select{ |n| n["animal_kind"] == "狗"}.size
    num_cat_ans = JSON.parse(ans).select{ |n| n["animal_kind"] == "貓"}.size

    it 'HAPPY: should connect to api successfully' do
      _(@project.request_body[0].keys).must_equal CORRECT[0].keys
      # _(project.git_url).must_equal CORRECT['git_url']
    end
    it 'HAPPY: should provide the same fields as same as the ones in CORRECT DATA' do
      # @project.conection
      _(@project.shelter_list.howmanyshelters).must_equal shelter_id_ans
      # _(project.git_url).must_equal CORRECT['git_url']
    end
    it 'HAPPY: should provide correct dog numbers in all shelters' do
      dog_number = @project.shelter_list.calculate_dog_nums
      _(dog_number).must_equal num_dog_ans # 10 should be modified with the correct data basedon dogCat_results
      # _(project.git_url).must_equal CORRECT['git_url']
    end
    it 'HAPPY: should provide correct cat numbers' do
      cat_number = @project.shelter_list.calculate_cat_nums
      _(cat_number).must_equal num_cat_ans
      # _(project.git_url).must_equal CORRECT['git_url']
    end

    it 'SAD: should raise exception on incorrect url' do
      path = "#{RESOURCE_PATH}/error_here"
      project = Info::Project.new(path)
      _(proc do
          project.connection
        end).must_raise Info::Response::NotFound
    end
  end
end
