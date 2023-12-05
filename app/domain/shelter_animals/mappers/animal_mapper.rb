# frozen_string_literal: true

require_relative '../entities/animal'
# create an animal object instance
module PetAdoption
  module Info
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

      def self.shelter_creation?(shelter_id, shelter_animal_mapping)
        shelter_animal_mapping[shelter_id] = {} unless shelter_animal_mapping.key?(shelter_id)
        shelter_animal_mapping[shelter_id]
      end

      def self.set_animal_mapping(animal_info_list, shelter_animal_mapping = {})
        animal_info_list.each do |animal_info|
          animal_shelter = AnimalMapper.shelter_creation?(animal_info['animal_shelter_pkid'], shelter_animal_mapping)
          animal, dogorcat = Info::AnimalMapper.find(animal_info)
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
            id:,
            remote_id:,
            cat_or_dog:,
            species:,
            age:,
            color:,
            sex:,
            sterilized:,
            animal_bodytype:,
            vaccinated:,
            bodytype:,
            image_url:,
            shelter:,
            registration_date:
          )
        end

        def build_cat_entity
          PetAdoption::Entity::Cat.new(
            id:,
            remote_id:,
            cat_or_dog:,
            species:,
            age:,
            color:,
            sex:,
            sterilized:,
            animal_bodytype:,
            vaccinated:,
            bodytype:,
            image_url:,
            shelter:,
            registration_date:
          )
        end

        # rubocop:enable Metrics/MethodLength
        private

        def id
          rand(1..1000)
        end

        def remote_id
          @data['animal_id']
        end

        def cat_or_dog
          @data['animal_kind']
        end

        def variate
          @data['animal_Variety']
        end

        def sex
          @data['animal_sex']
        end

        def sterilized
          @data['animal_sterilization'] == 'T'
        end

        def vaccinated
          @data['animal_bacterin'] == 'T'
        end

        def bodytype
          @data['animal_bodytype']
        end

        def image_url
          @data['album_file']
        end

        def shelter

        end

        def animal_opendate
          @data['animal_opendate']
        end

        def age
          @data['animal_age']
        end

        def color
          @data['animal_colour']
        end

        def registration_date
          @data['animal_foundplace']
        end
      end
    end
  end
end
