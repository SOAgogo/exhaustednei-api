require 'uri'
require 'net/http'
require 'pry'
require 'json'
require 'yaml'
# verify your identification

module Info
  class Project
    def initialize(uri)
      @url = URI(uri)
      @request_body = []
    end

    def connection
      url = URI(uri)
      # url.query = URI.encode_www_form(params)
      http = Net::HTTP.new(url.host, url.port)
      http.use_ssl = true
      request = Net::HTTP::Get.new(url)
      request['accept'] = 'application/json'
      response = http.request(request)
      # response.
      @request_body = JSON.parse(response.read_body)
    end

    def parser
      @request_body.each do |hash_value|
        # ShelterList.shelter_hash[field['']] = field['shelter_name'] if ShelterList.shelter_hash[field['shelter_name']] == nil
        animal_data_hash = {}
        shelter_data_hash = {}
        hash_value.each do |key,value|
          if %w[animal_place animal_shelter_pkid animal_id].include?(key)
            animal_data_hash[key] = value
            shelter_data_hash[key] = value
          elsif %w[animal_area_pkid shelter_name shelter_address shelter_tel].include?(key)
            shelter_data_hash[key] = value
          else
            animal_data_hash[key] = value
          end
        end
        send_hashingdata_to_animal_shelter(animal_data_hash, shelter_data_hash)
      end
    end

    def send_hashingdata_to_animal_shelter(_animal_data, _shelter_data)
      @animal_data_hash.map do |field|
        if field['animal_kind'] == '狗'
          dog = Dog.new(data)
        else
          cat = Cat.new(data)
        end
      end
    end
  end

  # params = {'$top'=>'20'}

  # puts body.instance_of? Hash
end
