# frozen_string_literal: true

module PetAdoption
  module Response
    # List of attractions
    AnimalList = Struct.new(:animal_obj_list)
    Animal = Struct.new(:animal)
  end
end
