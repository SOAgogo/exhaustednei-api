# frozen_string_literal: true

# manage the relationship between shelter and animal
module Info
  # class Info::ShelterMapper`
  class AnimalShelterMapper
    attr_reader :shelter_mapper

    # store the shelter hash that can access shelter object

    def initialize(project = Info::Project.new)
      @gateway_obj = project
      @shelter_mapper = ShelterMapper.new # store the shelter hash that can access shelter object
      # animal_hash = {} # store the animal hash that can access animal object
    end

    def set_shelter_mapper
      @shelter_mapper
    end

    def shelter_size
      @shelter_mapper.set_shelter_object.size
    end

    def create_shelter_obj(shelter_data)
      shelter_mapper_obj = set_shelter_mapper.set_shelter_object
      if shelter_mapper_obj[shelter_data['animal_shelter_pkid']].nil?
        @shelter_mapper.parse_shelter_data(shelter_data)
      else
        shelter_mapper_obj[shelter_data['animal_shelter_pkid']]
      end
    end

    def shelter_setting(shelter_obj, animal_data, animal_obj)
      @shelter_mapper.set_animal_object_list(animal_data['animal_id'], animal_obj)
      @shelter_mapper.set_cat_number if animal_obj.animal_kind == '貓'
      @shelter_mapper.set_dog_number if animal_obj.animal_kind == '狗'
    end

    def create_animal_shelter_object(shelter_data, animal_data)
      animal_obj = Info.AnimalMapper(animal_data).build_entity
      shelter_obj = create_shelter_obj(shelter_data)
      shelter_setting(shelter_obj, animal_data, animal_obj)
      shelter_obj
    end

    def shelter_parser
      @gateway_obj.request_body.each do |data|
        animal_data = Util::Util.animal_parser(data)
        shelter_data = Util::Util.shelter_parser(data)
        shelter_obj = create_animal_shelter_object(shelter_data, animal_data)
        @shelter_list[shelter_data['animal_shelter_pkid']] = shelter_obj
        # @shelter_list = shelter_initiator(@shelter_list, animal_data, shelter_data)
      end
    end
  end
end
