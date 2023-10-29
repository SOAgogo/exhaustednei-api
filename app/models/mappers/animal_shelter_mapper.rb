# frozen_string_literal: true

# manage the relationship between shelter and animal
require_relative 'animal_mapper'
require_relative 'shelter_mapper'
module EAS
  module Info
    # class Info::ShelterMapper`
    class AnimalShelterMapper
      attr_reader :shelter_mapper_hash

      # store the shelter hash that can access shelter object

      def initialize(project = Info::Project.new)
        @gateway_obj = project
        @shelter_mapper_hash = {} # store the animal hash that can access animal object
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

      def set_shelter_mapper_obj(animal_shelter_pkid, shelter_mapper_obj)
        @shelter_mapper_hash[animal_shelter_pkid] = shelter_mapper_obj
      end

      def get_shelter_mapper(animal_shelter_pkid)
        if @shelter_mapper_hash.key?(animal_shelter_pkid)
          [true, @shelter_mapper_hash[animal_shelter_pkid]]
        else
          [false, nil]
        end
      end

      def shelter_size
        @shelter_mapper_hash.size
      end

      def calculate_dog_nums
        sum = 0
        @shelter_mapper_hash.map do |_, obj|
          sum += obj.dog_number
        end
        sum
      end

      def calculate_cat_nums
        sum = 0
        @shelter_mapper_hash.map do |_, obj|
          sum += obj.cat_number
        end
        sum
      end

      # def get_the_shelter_mapper(animal_shelter_pkid)
      #   @shelter_mapper_hash[animal_shelter_pkid]
      # end

      def animal_size_in_shelter(animal_shelter_pkid)
        _, shelter = get_shelter_mapper(animal_shelter_pkid)

        shelter.cat_number + shelter.dog_number
      end

      def shelter_mapper_creation(shelter_id, shelter_data)
        get_or_not, shelter_mapper = get_shelter_mapper(shelter_id)
        shelter_mapper = ShelterMapper.new(shelter_data) unless get_or_not
        shelter_mapper
      end

      def shelter_mapper_setting(shelter_id, shelter_mapper)
        set_shelter_mapper_obj(shelter_id, shelter_mapper)
        shelter_mapper.setting_shelter_obj(shelter_mapper.find)
      end

      def create_shelter_mapper(shelter_data)
        shelter_id = shelter_data['animal_shelter_pkid']
        shelter_mapper = shelter_mapper_creation(shelter_id, shelter_data)
        shelter_mapper_setting(shelter_id, shelter_mapper)
        shelter_mapper
      end

      ## TODO: shelter_obj should have set_animal_object_list?
      def self.shelter_setting(shelter_mapper, animal_data, animal_obj)
        shelter_mapper.set_animal_object_hash(animal_data['animal_id'], animal_obj)
        if animal_obj.animal_kind == '貓'
          shelter_mapper.set_cat_number
        else
          shelter_mapper.set_dog_number
        end
      end

      # for creating the shelter_mapper to add the animal_obj
      def create_animal_shelter_object(shelter_data, animal_data)
        animal_obj = AnimalMapper.new(animal_data).find
        shelter_mapper = create_shelter_mapper(shelter_data)
        AnimalShelterMapper.shelter_setting(shelter_mapper, animal_data, animal_obj)
      end

      def shelter_parser
        @gateway_obj.request_body.each do |data|
          animal_data = AnimalShelterMapper.animal_parser(data)
          shelter_data = AnimalShelterMapper.shelter_parser(data)
          create_animal_shelter_object(shelter_data, animal_data)
        end
      end
    end
  end
end
