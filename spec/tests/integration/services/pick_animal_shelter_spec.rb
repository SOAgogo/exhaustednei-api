# frozen_string_literal: true

require_relative '../../../helpers/database_helper'
require 'securerandom'

describe 'select the right animal infos' do
  describe 'pick the animal right cover' do
    it 'HAPPY: should return correct animal cover stored in db' do
      # GIVEN: a valid project exists locally and is being watched
      animal_cover = PetAdoption::Services::PickAnimalCover.new.call
      db_cover = Database::ProjectOrm::AnimalOrm..exclude(album_file: '')
        .first
      animal_cover = animal_cover.value![:cover]
      _(db_cover.album_file).must_equal animal_cover
    end
  end
end
