# frozen_string_literal: true

require_relative '../entities/animal'
# create an animal object instance
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
      animal
    end

    def self.shelter_creation?(shelter_id, shelter_animal_mapping)
      shelter_animal_mapping[shelter_id] = {} unless shelter_animal_mapping.key?(shelter_id)
      shelter_animal_mapping[shelter_id]
    end

    def self.shelter_animal_mapping(animal_info_list)
      shelter_animal_mapping = {}
      animal_info_list.each do |animal_info|
        animal_shelter = AnimalMapper.shelter_creation?(animal_info['animal_shelter_pkid'], shelter_animal_mapping)
        animal_shelter[animal_info['animal_id']] = Info::AnimalMapper.find(animal_info)
      end
      shelter_animal_mapping
    end

    # # AnimalMapper::DataMapper
    class DataMapper
      def initialize(animal_info)
        @data = animal_info
      end

      def build_dog_entity
        Entity::Dog.new(
          id:,
          animal_id:,
          animal_kind:,
          animal_variate:,
          animal_sex:,
          animal_sterilization:,
          animal_bacterin:,
          animal_bodytype:,
          album_file:,
          animal_place:,
          animal_opendate:
        )
      end

      def build_cat_entity
        Entity::Cat.new(
          id:,
          animal_id:,
          animal_kind:,
          animal_variate:,
          animal_sex:,
          animal_sterilization:,
          animal_bacterin:,
          animal_bodytype:,
          album_file:,
          animal_place:,
          animal_opendate:
        )
      end

      private

      def id
        rand(1..1000)
      end

      def animal_id
        @data['animal_id']
      end

      def animal_kind
        @data['animal_kind']
      end

      def animal_variate
        @data['animal_Variety']
      end

      def animal_sex
        @data['animal_sex']
      end

      def animal_sterilization
        @data['animal_sterilization'] == 'T'
      end

      def animal_bacterin
        @data['animal_bacterin'] == 'T'
      end

      def animal_bodytype
        @data['animal_bodytype']
      end

      def album_file
        @data['album_file']
      end

      def animal_place
        @data['animal_place']
      end

      def animal_opendate
        @data['animal_opendate']
      end
    end
  end
end
