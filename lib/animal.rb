# frozen_string_literal: true

require 'uri'
require 'net/http'
require 'pry'
require 'json'
require 'yaml'
# verify your identification

module Info
  # class Info::Cat`
  class Cat
    attr_reader :animal_id, :animal_place, :animal_kind, :animal_variate, :animal_sex, :animal_sterilization,
                :animal_bacterin, :animal_bodytype, :album_file, :animal_opendate

    def initialize(data)
      @animal_id = data['animal_id'].to_i
      @animal_place = data['animal_place']
      @animal_kind = data['animal_kind']
      @animal_variate = data['animal_Variety']
      @animal_sex = data['animal_sex']
      @animal_sterilization = data['animal_sterilization'] == 'T'
      @animal_bacterin = data['animal_bacterin'] == 'T'
      @animal_bodytype = data['animal_bodytype']
      @album_file = data['album_file']
      @animal_opendate = data['animal_opendate']
    end

    def id
      animal_id
    end

    def place
      animal_place
    end

    def kind
      animal_kind
    end

    def gender
      animal_sex
    end

    def size
      animal_size
    end

    def sterilized?
      animal_sterilization
    end

    def bacterin?
      animal_bacterin
    end

    def variate(_pet)
      animal_variate
    end
  end

  # class Info::Dog`
  class Dog
    attr_reader :animal_id, :animal_place, :animal_kind, :animal_variate, :animal_sex, :animal_sterilization,
                :animal_bacterin, :animal_bodytype, :album_file, :animal_opendate

    def initialize(data)
      @animal_id = data['animal_id'].to_i
      @animal_place = data['animal_place']
      @animal_kind = data['animal_kind']
      @animal_variate = data['animal_Variety']
      @animal_sex = data['animal_sex']
      @animal_sterilization = data['animal_sterilization'] == 'T'
      @animal_bacterin = data['animal_bacterin'] == 'T'
      @animal_bodytype = data['animal_bodytype']
      @album_file = data['album_file']
      @animal_opendate = data['animal_opendate']
    end

    def id
      animal_id
    end

    def place
      animal_place
    end

    def kind
      animal_kind
    end

    def gender
      animal_sex
    end

    def size
      animal_size
    end

    def sterilized?
      animal_sterilization
    end

    def bacterin?
      animal_bacterin
    end

    def variate(_pet)
      animal_variate
    end
  end
end
