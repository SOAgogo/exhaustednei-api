require 'uri'
require "net/http"
require 'pry'
require 'json'
require 'yaml'
# verify your identification


begin
    uri = 'https://data.moa.gov.tw/Service/OpenData/TransService.aspx?UnitId=QcbUEzN6E6DL'
    # params = {'$top'=>'20'}
    url = URI(uri)
    #url.query = URI.encode_www_form(params)
    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true

    request = Net::HTTP::Get.new(url)
    request["accept"] = 'application/json'
    response = http.request(request)
    #response.
    body = JSON.parse(response.read_body)
    puts body.size
    #puts body.instance_of? Hash
end

