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
        def connection()
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
        def parser()
            
    end
  # params = {'$top'=>'20'}
  
  puts body
  # puts body.instance_of? Hash
end
