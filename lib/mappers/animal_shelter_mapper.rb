# frozen_string_literal: true

# manage the relationship between shelter and animal
module Info
  # class Info::ShelterMapper`
  class ShelterMapper
    attr_reader :shelter_list

    # store the shelter hash that can access shelter object

    def initialize(project = Info::Project.new)
      @gateway_obj = project
      @shelter_list = {} # store the shelter hash that can access shelter object
      # animal_hash = {} # store the animal hash that can access animal object
    end

    def getshelter
      @shelter_list
    end

    def shelter_size
      @shelter_list.size
    end

    def create_shelter_obj(shelter_data)
      if @shelter_list[shelter_data['animal_shelter_pkid']].nil?
        Info.ShelterMapper(shelter_data).build_entity
      else
        @shelter_list[shelter_data['animal_shelter_pkid']]
      end
    end

    def shelter_setting(shelter_obj, animal_data, animal_obj)
      shelter_obj.set_animal_object_hash(animal_data['animal_id'], animal_obj)
      shelter_obj.set_cat_number if animal_obj.animal_kind == '貓'
      shelter_obj.set_dog_number if animal_obj.animal_kind == '狗'
    end

    def create_animal_shelter_object(shelter_data, animal_data)
      animal_obj = Info.AnimalMapper(animal_data).build_entity
      shelter_obj = create_shelter_obj(shelter_data)
      shelter_setting(shelter_obj, animal_data, animal_obj)
      shelter_obj
    end

    def shelter_parser(body)
      body.each do |data|
        animal_data = Util::Util.animal_parser(data)
        shelter_data = Util::Util.shelter_parser(data)
        shelter_obj = create_animal_shelter_object(animal_data, shelter_data)
        @shelter_list[shelter_data['animal_shelter_pkid']] = shelter_obj
        # @shelter_list = shelter_initiator(@shelter_list, animal_data, shelter_data)
      end
    end

    # ShelterMapper::DataMapper
    class DataMapper
      @animal_attributes = {
        animal_object_hash:,
        cat_number:,
        dog_number:
      }

      def build_entity
        Entity.shelter.new(
          @animal_attributes
        )
      end
    end
  end
end
