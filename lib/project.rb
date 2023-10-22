# frozen_string_literal: true

require 'uri'
require 'net/http'
require 'pry'
require 'json'
require 'yaml'
# verify your identification
require_relative 'shelter'
require_relative 'animal'
module Info
  # class Info::Project`
  class Project
    attr_accessor :request_body, :shelter_list

    def initialize(uri)
      @uri = uri
      @request_body = []
      @shelter_list = nil
    end

    # def self.connection(uri)
    #   # url.query = URI.encode_www_form(params)
    #   url = URI(uri)
    #   http = Net::HTTP.new(url.host, url.port)
    #   http.use_ssl = true
    #   request = Net::HTTP::Get.new(url)
    #   request['accept'] = 'application/json'
    #   response = http.request(request)
    #   JSON.parse(response.read_body)
    # end
    def connection
      # url.query = URI.encode_www_form(params)
      url = URI(@uri)
      http = Net::HTTP.new(url.host, url.port)
      http.use_ssl = true
      request = Net::HTTP::Get.new(url)
      request['accept'] = 'application/json'
      response = http.request(request)
      @request_body = JSON.parse(response.read_body)[1..20]
    end

    def parser(data)
      animal_data_hash = {}
      shelter_data_hash = {}
      data.each do |key, value|
        if %w[animal_shelter_pkid animal_id].include?(key)
          animal_data_hash[key] = value
          shelter_data_hash[key] = value
        elsif %w[animal_area_pkid shelter_name shelter_address shelter_tel].include?(key)
          shelter_data_hash[key] = value
        else
          animal_data_hash[key] = value
        end
      end
      [animal_data_hash, shelter_data_hash]
    end

    def initiate_shelterlist
      @shelter_list = ShelterList.new
      @request_body.each do |hash_value|
        animal_data, shelter_data = parser(hash_value)
        shelter_initiator(animal_data, shelter_data)
        # @shelter_list = shelter_initiator(@shelter_list, animal_data, shelter_data)
      end
      # @shelter_list
    end

    # def shelter_initiator(shelter_list, animal_data, shelter_data)
    def shelter_initiator(animal_data, shelter_data)
      shelter = @shelter_list.shelter_hash[shelter_data['animal_shelter_pkid']]
      shelter = Shelter.new(shelter_data) if shelter.nil?
      
      if animal_data['animal_kind'] == '狗'
        dog = Dog.new(animal_data)
        shelter.animal_object_hash[animal_data['animal_id']] = dog
        shelter.dog_number += 1
      else
        cat = Cat.new(animal_data)
        shelter.animal_object_hash[animal_data['animal_id']] = cat
        shelter.cat_number += 1
      end
      # binding.pry
      @shelter_list.shelter_hash[shelter_data['animal_shelter_pkid']] = shelter
      # shelter_list
    end
  end

  # Response < SimpleDelegator
  class Response < SimpleDelegator
    Unauthorized = Class.new(StandardError)
    NotFound = Class.new(StandardError)

    HTTP_ERROR = {
      401 => Unauthorized,
      404 => NotFound
    }.freeze

    def successful?
      HTTP_ERROR.keys.none?(code)
    end

    def error
      HTTP_ERROR[code]
    end
  end
end
