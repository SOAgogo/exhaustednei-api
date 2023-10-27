# frozen_string_literal: true

# manage the relationship between shelter and animal
module Info
  # class Info::ShelterMapper`
  class ShelterMapper
    attr_reader :shelter_hash

    @shelter_list = {} # store the shelter hash that can access shelter object

    def initialize(project = Info::Project.new)
      @gateway_obj = project
      # shelter_hash = {} # store the shelter hash that can access shelter object
      # animal_hash = {} # store the animal hash that can access animal object
    end

    def getshelter
      @shelter_list.size
    end

    def self.create_shelter_obj(shelter_data)
      shelter_obj = if @shelter_list[shelter_data['animal_shelter_pkid']].nil?
                      Info.ShelterMapper(shelter_data).build_entity
                    else
                      @shelter_list[shelter_data['animal_shelter_pkid']]
                    end
    end

    def self.shelter_parser(body)
      body.each do |data|
        animal_data = Util::Util.animal_parser(data)
        shelter_data = Util::Util.shelter_parser(data)
        animal_obj = Info.AnimalMapper(animal_data).build_entity
        
        shelter_obj = create_shelter_obj(shelter_data)
        @shelter_list[shelter_data['animal_shelter_pkid']] = shelter_obj
        shelter_initiator(tempoary_shelter_hash, shelter_data)
        # @shelter_list = shelter_initiator(@shelter_list, animal_data, shelter_data)
      end
      #   @temporary_shelter_hash.animal_object_hash[animal_obj.animal_id] = animal_obj
      #   if animal_obj.animal_kind == '狗'
      #     shelter.dog_number += 1
      #   else
      #     shelter.cat_number += 1
      #   end
      #   @temporary_shelter_hash
    end

    def initiate_shelterlist
      @shelter_list = ShelterList.new
      @request_body.each do |hash_value|
        # animal_data = Util.parser(hash_value)
        animal_data = Util::Util.animal_parser(hash_value)
        shelter_data = Util::Util.shelter_parser(hash_value)
        shelter_initiator(animal_data, shelter_data)
        # @shelter_list = shelter_initiator(@shelter_list, animal_data, shelter_data)
      end
      # @shelter_list
    end

    def update_shelter(animal_data, shelter_data)
      shelter = @temporary_shelter_hash[shelter_data['animal_shelter_pkid']]
      shelter = Shelter.new if shelter.nil?
      Util::Util.animal_classifier(shelter, animal_data)
    end

    def shelter_initiator(animal_data, shelter_data)
      update_shelter(animal_data, shelter_data)
      @shelter_list.shelter_hash[shelter_data['animal_shelter_pkid']] = shelter
    end

    # ShelterMapper::DataMapper
    class DataMapper
      @animal_attributes = {
        animal_object_hash:,
        cat_number:,
        dog_number:
      }
      def initialize(shelter_data)
        @data = shelter_data
      end

      def build_entity
        Entity.shelter.new(
          @animal_attributes
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
