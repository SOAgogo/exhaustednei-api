# frozen_string_literal: true

# manage the relationship between shelter and animal
require_relative 'animal_mapper'
require_relative 'shelter_mapper'
require 'pry'
module Info
  # class Info::ShelterMapper`
  class AnimalShelterMapper
    attr_reader :shelter_list, :shelter_mapper

    # store the shelter hash that can access shelter object

    def initialize(project = Info::Project.new)
      @gateway_obj = project
      @shelter_list = {} # store the shelter hash that can access shelter object
      @shelter_mapper = ShelterMapper.new # store the animal hash that can access animal object
    end

    def set_shelter_list
      @shelter_list
    end

    def shelter_size
      @shelter_list.size
    end

    def calculate_dog_nums
      sum = 0
      @shelter_list.map do |_, obj|
        sum += obj.dog_number
      end
      sum
    end

    def calculate_cat_nums
      sum = 0
      @shelter_list.map do |_, obj|
        sum += obj.cat_number
      end
      sum
    end

    def get_the_shelter(animal_area_pkid)
      @shelter_list[animal_area_pkid]
    end

    def animal_size_in_shelter(animal_area_pkid)
      @shelter_list[animal_area_pkid].animal_nums
    end

    def create_shelter_obj(shelter_data)
      shelter_list = set_shelter_list
      if shelter_list[shelter_data['animal_shelter_pkid']].nil?
        # binding.pry
        @shelter_mapper.find(shelter_data)
      else
        shelter_list[shelter_data['animal_shelter_pkid']]
      end
    end

    ## TODO: shelter_obj should have set_animal_object_list?
    # shelter.rb set_animal_object_list
    def shelter_setting(shelter_obj, animal_data, animal_obj)
      shelter_obj.set_animal_object_list(animal_data['animal_id'], animal_obj)
      shelter_obj.set_cat_number if animal_obj.animal_kind == '貓'
      shelter_obj.set_dog_number if animal_obj.animal_kind == '狗'
    end

    def create_animal_shelter_object(shelter_data, animal_data)
      animal_obj = AnimalMapper.new(animal_data).find
      shelter_obj = create_shelter_obj(shelter_data)

      shelter_setting(shelter_obj, animal_data, animal_obj)
      shelter_obj
    end

    def shelter_parser
      @gateway_obj.request_body.each do |data|
        animal_data = Util::Util.animal_parser(data)
        shelter_data = Util::Util.shelter_parser(data)
        shelter_obj = create_animal_shelter_object(shelter_data, animal_data)
        set_shelter_list[shelter_data['animal_shelter_pkid']] = shelter_obj
        # @shelter_list[shelter_data['animal_shelter_pkid']] = shelter_obj
        # @shelter_list = shelter_initiator(@shelter_list, animal_data, shelter_data)
      end
    end
  end
end
