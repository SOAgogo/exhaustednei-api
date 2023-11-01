# frozen_string_literal: true

require_relative '../entities/animal'
# create an animal object instance
module Info
  # class Info::ShelterMapper`
  class AnimalMapper
    def initialize(animal_data_list)
      @animal_info_list = animal_data_list
    end

    def find(animal_info)
      DataMapper.new(animal_info).build_entity
      # @animal_object_hash[animal_obj.animal_id] = animal_obj
    end

    def shelter_animal_mapping
      shelter_animal_mapping = {}
      shelter_id = animal_info['animal_shelter_pkid']
      @animal_info_list.each do |animal_info|
        shelter_animal_mapping[shelter_id] = [] if shelter_animal_mapping[shelter_id].empty?
        shelter_animal_mapping[shelter_id] << find(animal_info)
      end
      shelter_animal_mapping
    end

    # # AnimalMapper::DataMapper
    class DataMapper
      def initialize(animal_data_list)
        @animal_data_list = animal_data_list
      end

      def build_entity
        Entity::Animal.new(
          animal_id:,
          animal_kind:,
          animal_variate:,
          animal_sex:,
          animal_sterilization:,
          animal_bacterin:,
          animal_bodytype:,
          album_file:
        )
      end

      private

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

      # def animal_place
      #   @data['animal_place']
      # end

      # def animal_opendate
      #   @data['animal_opendate']
      # end
    end
  end
end
