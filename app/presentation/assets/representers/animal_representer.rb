# frozen_string_literal: true

require 'roar/decorator'
require 'roar/json'

module PetAdoption
  module Representer
    # Represents essential Member information for API output
    # USAGE:
    #   member = Database::MemberOrm.find(1)
    #   Representer::Member.new(member).to_json
    class Animal< Roar::Decorator
      include Roar::JSON

      property :id
      property :animal_id
      property :animal_kind
      property :animal_variate
      property :animal_age
      property :animal_color
      property :animal_sex
      property :animal_sterilization
      property :animal_bacterin
      property :animal_bodytype
      property :animal_found_place
      property :album_file
      property :animal_place
      property :animal_opendate
    end
  end
end