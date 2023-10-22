require 'uri'
require 'net/http'
require 'pry'
require 'json'
require 'yaml'
# verify your identification

module Info
  class Cat
    attr_reader :animal_ID, :animal_place, :animal_kind, :animal_variate, :animal_sex, :animal_sterilization,
                :animal_bacterin, :animal_bodytype, :album_file, :animal_opendate

    def initialize(data)
      @animal_ID = data['animal_id'].to_i
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
  end

  class Dog
    attr_reader :animal_ID, :animal_place, :animal_kind, :animal_variate, :animal_sex, :animal_sterilization,
                :animal_bacterin, :animal_bodytype, :album_file, :animal_opendate

    def initialize(data)
      @animal_ID = data['animal_id'].to_i
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
  end
end
