# frozen_string_literal: true

require_relative '../entities/animals'

# create an animal object instance
module PetAdoption
  module Mapper
    # class Info::ShelterMapper`
    class AnimalMapper
      attr_reader :animal_info_list

      def initialize(animal_data_list)
        @animal_info_list = animal_data_list
      end

      def self.find(animal_info)
        kind = animal_info['animal_kind']
        animal = DataMapper.new(animal_info).build_dog_entity if kind == '狗'
        animal = DataMapper.new(animal_info).build_cat_entity if kind == '貓'
        if %w[貓 狗].include?(kind)
          [animal, true]
        else
          [animal, false]
        end
      end

      def self.shelter_creation?(shelter_name, shelter_animal_mapping)
        shelter_animal_mapping[shelter_name] = {} unless shelter_animal_mapping.key?(shelter_name)
        shelter_animal_mapping[shelter_name]
      end

      def self.set_animal_mapping(animal_info_list, shelter_animal_mapping = {})
        animal_info_list.each do |animal_info|
          animal_shelter = AnimalMapper.shelter_creation?(animal_info['animal_place'], shelter_animal_mapping)
          animal, dogorcat = AnimalMapper.find(animal_info)
          animal_shelter[animal_info['animal_id']] = animal if dogorcat
        end
        shelter_animal_mapping
      end

      def self.shelter_animal_mapping(animal_info_list)
        set_animal_mapping(animal_info_list)
      end

      # # AnimalMapper::DataMapper
      # This method smells of :reek:TooManyMethods
      class DataMapper
        def initialize(animal_info)
          @data = animal_info
        end

        # rubocop:disable Metrics/MethodLength
        def build_dog_entity
          PetAdoption::Entity::Dog.new(
            remote_id:,
            species:,
            age:,
            color:,
            sex:,
            sterilized:,
            bodytype:,
            vaccinated:,
            image_url:,
            registration_date:
          )
        end

        def build_cat_entity
          PetAdoption::Entity::Cat.new(
            remote_id:,
            species:,
            age:,
            color:,
            sex:,
            sterilized:,
            bodytype:,
            vaccinated:,
            image_url:,
            registration_date:
          )
        end

        # rubocop:enable Metrics/MethodLength
        private

        def remote_id
          @data['animal_id']
        end

        def species
          @data['animal_Variety'].gsub(/\s+/, '')
        end

        def age
          @data['animal_age']
        end

        def color
          @data['animal_colour']
        end

        def sex
          @data['animal_sex']
        end

        def sterilized
          @data['animal_sterilization'] == 'T'
        end

        def bodytype
          @data['animal_bodytype']
        end

        def vaccinated
          @data['animal_bacterin'] == 'T'
        end

        def image_url
          @data['album_file']
        end

        def registration_date
          if @data['animal_opendate'] == ''
            Time.parse(@data['animal_createtime'])
          else
            Time.parse(@data['animal_opendate'])
          end
        end
      end
    end
  end
end
