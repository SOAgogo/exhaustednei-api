# frozen_string_literal: true

module Info
  # class Info::ShelterMapper`
  class AnimalMapper
    attr_reader :animal_object_hash

    def initialize(animal_data)
      @animal_object_hash = parse_animal_data(animal_data)
    end

    def parse_animal_data(data)
      #   animal_object_hash = {}
      #   animal_data.each do |key, value|
      #     animal_object_hash[key] = value unless %w[animal_area_pkid shelter_name shelter_address
      #                                               shelter_tel].include?(key)
      #   end
      #   animal_object_hash
      DataMapper.new(data).build_entity

      animal_data_hash
    end

    class DataMapper
      def initialize(animal_data)
        @data = animal_data
      end

      def build_entity
        Entity.animal.new(
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

      def animal_id
        @data['animal_id']
      end

      def animal_kind
        @data['animal_kind']
      end

      def animal_variate
        @data['animal_variate']
      end
    end
  end
end
