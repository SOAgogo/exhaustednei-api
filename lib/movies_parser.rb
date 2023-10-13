require 'uri'
require "net/http"
require 'pry'
require 'json'
require 'yaml'
# verify your identification

def verifier(uri,token)
    url = URI(uri)
    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true

    request = Net::HTTP::Get.new(url)
    request["accept"] = 'application/json'
    request["Authorization"] = 'Bearer '+token 
    response = http.request(request)


    body = JSON.parse(response.read_body)
    
    raise StandardError, body['status_message'] unless body['success']
    return true 
    # return false
end
def parser(website_uri,token)
    url = URI(website_uri)
    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true

    request = Net::HTTP::Get.new(url)
    request["accept"] = 'application/json'
    request["Authorization"] = 'Bearer '+ token 
    response = http.request(request)

    body = JSON.parse(response.read_body)
    return body
end

def verifier_parser(verify_uri,website_uri,token)
    return parser(website_uri,token) if verifier(verify_uri,token)
end

def write_file(path,body)
    File.write(path, body.to_yaml)
end

begin
    verify_uri = "https://api.themoviedb.org/3/authentication"
    token = 'eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiIwNzEzNDA1ODBmNTA3NTU3M2IyZjZiODhjM2E0MWVmZSIsInN1YiI6IjY1MjkxM2Q1Mzc4MDYyMDEzOWExOGZiNiIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.Yqm6Vnogx8KWsk0mJ1nqlmoY6KzUHB5JKG7CnyJPK24'
    website_uri = "https://api.themoviedb.org/3/tv/95479"
    file_name = ARGV[0]
    path = File.expand_path(File.join(File.dirname(__FILE__), "../spec/fixtures/#{file_name}"))
    puts path
    body = verifier_parser(verify_uri,website_uri,token)
    write_file(path,body)

    #puts body.instance_of? Hash
end


# binding.pry
