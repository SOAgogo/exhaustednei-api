# frozen_string_literal: true

require 'uri'
require 'net/http'
require 'json'
require 'yaml'
# verify your identification

module PetAdoption
  module Info
    # class Info::Project`
    class Project
      attr_reader :request_body, :shelter_list

      def initialize(uri)
        @uri = uri
        @request_body = connection
      end

      def setup_url
        url = URI(@uri)
        http = Net::HTTP.new(url.host, url.port)
        http.use_ssl = true
        [url, http]
      end

      def self.read_body(url, http)
        request = Net::HTTP::Get.new(url)
        request['accept'] = 'application/json'
        http.request(request).read_body
      end

      def connection
        url, http = setup_url
        response_body = Project.read_body(url, http)

        JSON.parse(response_body)[1..20]
      end
    end
  end
end
