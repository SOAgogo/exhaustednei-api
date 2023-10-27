# frozen_string_literal: true

# create an shelter object instance
module Info
  # class Info::ShelterMapper`
  class ShelterMapper
    attr_reader :animal_obj_list

    # store the shelter hash that can access shelter object

    def initialize
      @animal_obj_list = {}
      #   @shelter_list = ShelterList.shelter_animal_parser(@gateway_obj.request_body)
    end



    # def initiate_shelterlist
    #   @shelter_list = ShelterList.new
    #   @request_body.each do |hash_value|
    #     # animal_data = Util.parser(hash_value)
    #     animal_data = Util::Util.animal_parser(hash_value)
    #     shelter_data = Util::Util.shelter_parser(hash_value)
    #     shelter_initiator(animal_data, shelter_data)
    #     # @shelter_list = shelter_initiator(@shelter_list, animal_data, shelter_data)
    #   end
    #   # @shelter_list
    # end

    # def update_shelter(animal_data, shelter_data)
    #   shelter = @temporary_shelter_hash[shelter_data['animal_shelter_pkid']]
    #   shelter = Shelter.new if shelter.nil?
    #   Util::Util.animal_classifier(shelter, animal_data)
    # end

    # def shelter_initiator(animal_data, shelter_data)
    #   update_shelter(animal_data, shelter_data)
    #   @shelter_list.shelter_hash[shelter_data['animal_shelter_pkid']] = shelter
    # end

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
    # ShelterMapper::DataMapper
    class DataMapper
      @shelter_attributes = {
        animal_object_hash:,
        cat_number:,
        dog_number:
      }
      def initialize(shelter_data)
        @data = shelter_data
      end

      def build_entity
        Entity.shelter.new(
          @shelter_attributes
        )
      end

      private

      def animal_object_hash
        {}
      end

      def cat_number
        0
      end

      def dog_number
        0
      end
    end
  end
end
