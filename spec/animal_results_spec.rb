# frozen_string_literal: true

require 'pry'
require_relative 'spec_helper'

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
      @animal_shelter_initator = Info::AnimalShelterInitiator.new(@project)
      @shelter_mapper, @animal_mapper = @animal_shelter_initator.init
      # @project.shelter_list = @project.initiate_shelterlist
      @shelter_mapper.create_all_shelter_animal_obj(@animal_mapper.shelter_animal_mapping)
    end

    ans = File.read('spec/fixtures/DogCat_results.json')
    file = JSON.parse(ans)
    random = rand(0..19)
    shelter_id_ans = file.map { |n| n['animal_shelter_pkid'] }.uniq.size
    num_dog_ans = file.select { |n| n['animal_kind'] == '狗' }.size
    num_cat_ans = file.select { |n| n['animal_kind'] == '貓' }.size
    rand_shelter_id = file[random]['animal_shelter_pkid']
    num_aml_shelter_ans = file.select { |n| n['animal_shelter_pkid'] == rand_shelter_id }.size

    it 'HAPPY: should connect to api successfully' do
      _(@project.request_body[0].keys).must_equal CORRECT[0].keys
      # _(project.git_url).must_equal CORRECT['git_url']
    end
    it 'HAPPY: should provide the same fields as same as the ones in CORRECT DATA' do
      # @project.conection
      _(@shelter_mapper.shelter_size).must_equal shelter_id_ans
      # _(project.git_url).must_equal CORRECT['git_url']
    end
    it 'HAPPY: should provide correct dog numbers in all shelters' do
      dog_number = @shelter_mapper.calculate_dog_nums
      _(dog_number).must_equal num_dog_ans # 10 should be modified with the correct data basedon dogCat_results
      # _(project.git_url).must_equal CORRECT['git_url']
    end
    it 'HAPPY: should provide correct cat numbers' do
      cat_number = @shelter_mapper.calculate_cat_nums
      _(cat_number).must_equal num_cat_ans
      # _(project.git_url).must_equal CORRECT['git_url']
    end

    ## TODO: right number
    it 'HAPPY: shelter should provide the correct animal numbers' do
      aml_number = @shelter_mapper.animal_size_in_shelter(rand_shelter_id)
      _(aml_number).must_equal num_aml_shelter_ans
      # _(project.git_url).must_equal CORRECT['git_url']
    end

    ## TODO:
    it 'HAPPY: get the right animal id and its information' do
      # _, shelter_mapper = @animal_shelter_mapper.get_shelter_mapper(rand_shelter_id)
      # binding.pry
      # random_id = file[random]['animal_id']
      animal = @shelter_mapper.find_animal_in_shelter(rand_shelter_id, random_id) # shelter_id, animal_id
      #   _(shelter_mapper.animal_object_hash[random_id].animal_id).must_equal file[random]['animal_id']
      #   _(shelter_mapper.animal_object_hash[random_id].animal_bodytype).must_equal file[random]['animal_bodytype']
      #   _(shelter_mapper.animal_object_hash[random_id].animal_variate).must_equal file[random]['animal_Variety']
      _(animal.animal_id).must_equal file[random]['animal_id']
      _(animal.animal_bodytype).must_equal file[random]['animal_bodytype']
      _(animal.animal_variate).must_equal file[random]['animal_Variety']
    end

    it 'SAD: should raise exception on incorrect url' do
      path = "#{RESOURCE_PATH}/error_here"
      project = Info::Project.new(path)
      project.connection
      _(
        project.request_body.to_s
      ).must_equal ''
    end

    it 'HAPPY: should provide correct animal numbers in each shelter' do
      aml_number = @shelter_mapper.animal_size_in_shelter(rand_shelter_id)
      _(aml_number).must_equal num_aml_shelter_ans
    end
  end
end
