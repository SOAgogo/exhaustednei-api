# frozen_string_literal: true

require_relative '../../app/infrastructure/download/curl_download_file'
module Repository
  module App
    # init_database for initializing database
    class PrepareDatabase
      def self.init_database
        project = PetAdoption::CurlDownload::FileDownloader.new
        animal_shelter_initator = PetAdoption::Info::AnimalShelterInitiator.new(project)
        shelter_mapper, animal_mapper = animal_shelter_initator.init
        shelter_mapper.create_all_shelter_animal_obj(
          PetAdoption::Info::AnimalMapper.shelter_animal_mapping(animal_mapper.animal_info_list)
        )
        PrepareDatabase.store_shelter_info_to_db(project)
      end

      def self.store_shelter_info_to_db(project)
        project.request_body.each do |shelter_obj|
          shelter = PetAdoption::Info::ShelterMapper.get_shelter_obj(shelter_obj['animal_shelter_pkid'])
          Repository::Info::For.entity(shelter).db_find_or_create(shelter)
        end
      end
    end
  end
end
