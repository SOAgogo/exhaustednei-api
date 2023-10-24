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
    # attr_accessor :request_body, :shelter_list
    attr_reader :request_body, :shelter_list

    # def initialize(uri)
    #   @uri = uri
    #   @request_body = []
    #   @shelter_list = nil
    # end
    def initialize(request_body)
      @request_body = request_body
      @shelter_list = nil
    end

    def self.connection(uri)
      # url.query = URI.encode_www_form(params)
      url = URI(uri)
      http = Net::HTTP.new(url.host, url.port)
      http.use_ssl = true
      request = Net::HTTP::Get.new(url)
      request['accept'] = 'application/json'
      response = http.request(request)
      JSON.parse(response.read_body)[1..20]
    end

    # def animal_parser(data, animal_data_hash = {})
    #   data.each do |key, value|
    #     animal_data_hash[key] = value unless %w[animal_area_pkid shelter_name shelter_address
    #                                             shelter_tel].include?(key)
    #   end
    #   animal_data_hash
    # end

    # def shelter_parser(data, shelter_data_hash = {})
    #   data.each do |key, value|
    #     shelter_data_hash[key] = value if %w[animal_area_pkid shelter_name shelter_address shelter_tel].include?(key)
    #   end
    #   shelter_data_hash
    # end
    def animal_parser(data)
      animal_data_hash = {}
      data.each do |key, value|
        animal_data_hash[key] = value unless %w[animal_area_pkid shelter_name shelter_address shelter_tel].include?(key)
      end
      animal_data_hash
    end

    def shelter_parser(data)
      shelter_data_hash = {}
      data.each do |key, value|
        if %w[animal_shelter_pkid animal_id animal_area_pkid shelter_name shelter_address shelter_tel].include?(key)
          shelter_data_hash[key] = value
        end
      end
      shelter_data_hash
    end

    def initiate_shelterlist
      @shelter_list = ShelterList.new
      @request_body.each do |hash_value|
        animal_data = animal_parser(hash_value)
        shelter_data = shelter_parser(hash_value)
        # animal_data, shelter_data = parser(hash_value)
        shelter_initiator(animal_data, shelter_data)
        # @shelter_list = shelter_initiator(@shelter_list, animal_data, shelter_data)
      end
      # @shelter_list
    end

    # def shelter_initiator(shelter_list, animal_data, shelter_data)
    def shelter_initiator(animal_data, shelter_data)
      shelter = @shelter_list.shelter_hash[shelter_data['animal_shelter_pkid']]
      shelter = Shelter.new(shelter_data) if shelter.nil?
      shelter = animal_classifier(animal_data, shelter)
      @shelter_list.shelter_hash[shelter_data['animal_shelter_pkid']] = shelter
    end

    def put_the_animal_into_shelter(shelter, animal_obj, dog_or_not = false)
      shelter.animal_object_hash[animal_obj.animal_id] = animal_obj
      if dog_or_not
        shelter.dog_number += 1
      else
        shelter.cat_number += 1
      end
      shelter
    end

    def animal_classifier(animal_data, shelter)
      if animal_data['animal_kind'] == '狗'
        dog = Dog.new(animal_data)
        shelter = put_the_animal_into_shelter(shelter, dog, true)
      elsif animal_data['animal_kind'] == '貓'
        cat = Cat.new(animal_data)
        shelter = put_the_animal_into_shelter(shelter, cat)
      end
      shelter
    end
  end
end
