# frozen_string_literal: true

require_relative '../../app/infrastructure/gateways/animalweb_api'
require_relative '../../app/models/mappers/animal_shelter_initiator'
require_relative 'database_helper'

module Repository
  module App
    # init_database for initializing database
    class PrepareDatabase
      def self.init_database
        DatabaseHelper.wipe_database
        project = Info::Project.new(RESOURCE_PATH)
        animal_shelter_initator = Info::AnimalShelterInitiator.new(project)
        shelter_mapper, animal_mapper = animal_shelter_initator.init
        shelter_mapper.create_all_shelter_animal_obj(
          Info::AnimalMapper.shelter_animal_mapping(animal_mapper.animal_info_list)
        )
        store_shelter_info_to_db
      end

      def self.store_shelter_info_to_db
        20.times do |i|
          shelter = Info::ShelterMapper.get_shelter_obj(CORRECT[i]['animal_shelter_pkid'])
          Repository::Info::For.entity(shelter).create(shelter)
        end
      end
    end
  end
end
