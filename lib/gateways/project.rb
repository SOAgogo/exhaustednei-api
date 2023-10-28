# frozen_string_literal: true

require 'uri'
require 'net/http'
require 'json'
require 'yaml'
# verify your identification

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
    def initialize(uri)
      @request_body = connection(uri)
      # @shelter_list = nil
    end

    def setup_url(uri)
      url = URI(uri)
      http = Net::HTTP.new(url.host, url.port)
      http.use_ssl = true
      [url, http]
    end

    def connection(uri)
      url, http = setup_url(uri)
      request = Net::HTTP::Get.new(url)
      request['accept'] = 'application/json'
      response = http.request(request)
      JSON.parse(response.read_body)[1..20]
    end
  end
end
