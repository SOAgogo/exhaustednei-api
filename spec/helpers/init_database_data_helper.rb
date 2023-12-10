# frozen_string_literal: true

require_relative '../../app/infrastructure/download/curl_download_file'
require_relative '../../app/domain/shelter_animals/mappers/animal_shelter_initiator'
require_relative '../../app/domain/shelter_animals/mappers/animal_mapper'
require_relative '../../app/domain/shelter_animals/mappers/shelter_mapper'
require_relative '../../app/domain/shelter_animals/repositories/for'
require 'pry'
module Repository
  module App
    # init_database for initializing database
    class PrepareDatabase
      def self.init_database
        project = PetAdoption::CurlDownload::FileDownloader.new
        animal_shelter_initator = PetAdoption::Mapper::AnimalShelterInitiator.new(project)
        countyshelter_mapper, animal_mapper = animal_shelter_initator.init

        countyshelter_mapper.create_all_shelter_animal_obj(
          PetAdoption::Mapper::AnimalMapper.shelter_animal_mapping(animal_mapper.animal_info_list)
        )

        a = countyshelter_mapper.build_entity('臺北市')
        binding.pry 
        PrepareDatabase.store_shelter_info_to_db(project)
      end

      def self.store_shelter_info_to_db(project)
        project.request_body.each do |shelter_obj|
          shelter = PetAdoption::Mapper::ShelterMapper.get_shelter_obj(shelter_obj['shelter_name'])
          Repository::Info::For.entity(shelter).db_find_or_create(shelter)
        end
      end
    end
  end
end
