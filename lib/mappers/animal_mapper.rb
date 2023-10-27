# frozen_string_literal: true

# create an animal object instance
module Info
  # class Info::ShelterMapper`
  class AnimalMapper
    attr_reader :animal_object_hash

    def initialize(data)
      @animal_info = data
    end

    def parse_animal_data
      DataMapper.new(@animal_info).build_entity
      # @animal_object_hash[animal_obj.animal_id] = animal_obj
    end

    # AnimalMapper::DataMapper
    class DataMapper
      @animal_attributes = {
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
      }
      def initialize(animal_data)
        @data = animal_data
      end

      def build_entity
        Entity.animal.new(
          @animal_attributes
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
        @data['animal_variate']
      end

      def animal_sex
        @data['animal_sex']
      end

      def animal_sterilization
        @data['animal_sterilization']
      end

      def animal_bacterin
        @data['animal_bacterin']
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
