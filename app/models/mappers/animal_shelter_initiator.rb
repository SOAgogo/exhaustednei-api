# frozen_string_literal: true

# manage the relationship between shelter and animal
require_relative 'animal_mapper'
require_relative 'shelter_mapper'

module Info
  # class Info::ShelterMapper`
  class AnimalShelterInitiator
    attr_reader :shelter_mapper_hash

    # store the shelter hash that can access shelter object

    def initialize(project = Info::Project.new)
      @gateway_obj = project
      # store the animal hash that can access animal object
    end

    def self.animal_parser(data)
      animal_data_hash = {}
      data.each do |key, value|
        animal_data_hash[key] = value unless %w[animal_area_pkid shelter_name shelter_address
                                                shelter_tel].include?(key)
      end
      animal_data_hash
    end

    def self.shelter_parser(data)
      shelter_data_hash = {}
      data.each do |key, value|
        shelter_data_hash[key] = value if %w[animal_area_pkid animal_shelter_pkid shelter_name shelter_address
                                             shelter_tel].include?(key)
      end
      shelter_data_hash
    end

    # def get_the_shelter_mapper(animal_shelter_pkid)
    #   @shelter_mapper_hash[animal_shelter_pkid]
    # end

    # for creating the shelter_mapper to add the animal_obj
    def create_animal_shelter_object(shelter_data, animal_data)
      animal_obj = AnimalMapper.new(animal_data).find
      shelter_mapper = create_shelter_mapper(shelter_data)
      AnimalShelterMapper.shelter_setting(shelter_mapper, animal_data, animal_obj)
    end

    # refactor for some reek errors
    def animal_parser
      animal_data_list = []
      @gateway_obj.request_body.each do |data|
        animal_data_list << AnimalShelterInitiator.animal_parser(data)
      end
      animal_data_list
    end

    def shelter_parser
      shelter_data_list = []
      @gateway_obj.request_body.each do |data|
        shelter_data_list << AnimalShelterInitiator.shelter_parser(data)
      end
      shelter_data_list
    end

    def init
      animal_data_list = animal_parser
      shelter_data_list = shelter_parser
      shelter_mapper = ShelterMapper.new(shelter_data_list)
      animal_mapper = AnimalMapper.new(animal_data_list)
      [shelter_mapper, animal_mapper]
    end
  end
end