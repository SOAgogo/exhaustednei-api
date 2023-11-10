# frozen_string_literal: true

require_relative 'database_helper'
require_relative '../spec_helper'
module Repository
  module App
    # init_database for initializing database
    class PrepareDatabase
      def self.init_database
        project = PetAdoption::Info::Project.new(RESOURCE_PATH)
        animal_shelter_initator = PetAdoption::Info::AnimalShelterInitiator.new(project)
        shelter_mapper, animal_mapper = animal_shelter_initator.init
        shelter_mapper.create_all_shelter_animal_obj(
          PetAdoption::Info::AnimalMapper.shelter_animal_mapping(animal_mapper.animal_info_list)
        )
        PrepareDatabase.store_shelter_info_to_db
      end

      def self.store_shelter_info_to_db
        (0..19).map do |time|
          shelter = PetAdoption::Info::ShelterMapper.get_shelter_obj(CORRECT[time]['animal_shelter_pkid'])
          Repository::Info::For.entity(shelter).create(shelter)
        end
      end
    end
  end
end
