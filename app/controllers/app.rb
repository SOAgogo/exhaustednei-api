# frozen_string_literal: true

require 'roda'
require 'slim'
require 'slim/include'
require 'json'
require 'uri'
require 'securerandom'
require 'securerandom'
require 'fileutils'


module PetAdoption
  # Web App
  class App < Roda
    plugin :all_verbs
    plugin :render, engine: 'slim', views: 'app/views'
    plugin :assets, path: 'app/views/assets', css: 'style.css'
    # plugin :assets, css: 'style.css', path: 'app/views/assets/css'
    plugin :common_logger, $stderr
    plugin :halt
    plugin :json


    # use Rack::MethodOverride

    route do |routing|
      routing.assets # load CSS
      response['Content-Type'] = 'text/html; charset=utf-8'

      # GET /
      routing.root do
        session[:watching] ||= {}
        routing.redirect 'home' if session[:watching][:session_id]
        view('signup')
        # view('addtolist')
      end

      routing.post 'signup' do
        firstname = routing.params['first_name']
        lastname = routing.params['last_name']
        email = routing.params['email']
        phone = routing.params['phone']
        address = routing.params['address']
        willingness = routing.params['state']
        session_id = SecureRandom.uuid

        puts "session_id: #{session_id.class} willingness: #{willingness}"

        cookie_hash = { 'session_id' => session_id,
                        'firstname' => firstname,
                        'lastname' => lastname,
                        'phone' => phone,
                        'email' => email,
                        'address' => address,
                        'willingness' => willingness }

        if ENV['testing'] == 'true'
          open('spec/testing_cookies/user_input.json', 'w') do |file|
            file << cookie_hash.to_json
          end
        end
        user = PetAdoption::Adopters::DonatorMapper.new(cookie_hash).find if willingness == 'donater'
        user = PetAdoption::Adopters::AdopterMapper.new(cookie_hash).find if willingness == 'adopter'
        user = PetAdoption::Adopters::KeeperMapper.new(cookie_hash).find if willingness == 'keeper'

        Repository::Adopters::Users.new(
          user.to_attr_hash.merge(
            address: URI.decode_www_form_component(user.address)
          )
        ).create_user
        session[:watching] = cookie_hash
        routing.redirect '/home'
      end

      routing.on 'home' do
        routing.is do
          animal_pic = Repository::Info::Animals.web_page_cover
          view 'home', locals: { image_url: animal_pic }
        end
      end

      routing.on 'animal' do
        routing.is do
          routing.post do
            animal_kind = routing.params['animal_kind'].downcase
            shelter_name = routing.params['shelter_name']
            sn_ch = URI.decode_www_form_component(shelter_name)

            routing.redirect "animal/#{animal_kind}/#{sn_ch}"
          end
        end

        routing.on String, String do |animal_kind, shelter_name|
          # GET /project/owner/project
          ak_ch = animal_kind == 'dog' ? '狗' : '貓'
          shelter_name = URI.decode_www_form_component(shelter_name)
          animal_kind = URI.decode_www_form_component(ak_ch)
          # animal_obj_hash = Repository::Info::Animals.select_animal_by_shelter_name('狗', '高雄市壽山動物保護教育園區')
          animal_obj_hash = Repository::Info::Animals.select_animal_by_shelter_name(animal_kind, shelter_name)

          # can this follwoing codes which decode chinese words be put the other side?

          animal_obj_hash.each do |key, obj|
            obj.to_decode_hash.merge(
              animal_kind: URI.decode_www_form_component(obj.animal_kind),
              animal_variate: URI.decode_www_form_component(obj.animal_variate),
              animal_place: URI.decode_www_form_component(obj.animal_place),
              animal_found_place: URI.decode_www_form_component(obj.animal_found_place),
              animal_age: URI.decode_www_form_component(obj.animal_age),
              animal_color: URI.decode_www_form_component(obj.animal_color)
            )
            animal_obj_hash[key] = obj
          end

          view 'project', locals: {
            animal_obj_hash:
          }
        end
      end

      routing.on 'adopt' do
        # POST /adopt
        routing.post do
          # Perform any necessary processing for the 'Adopt?' button click
          # ...
    
          # Render the 'adopt.slim' file
          view 'adopt'
    
          # Redirect to the desired page
        end
      end
      routing.on 'found' do
        routing.post do
          script_path = 'app/controllers/classification.py'
          if routing.params['file0'].is_a?(Hash)
            #uploaded_file = File.basename(routing.params['file0'][:tempfile].path)
            uploaded_file = routing.params['file0'][:tempfile].path
          end
        
          # Use Open3 to run the Python script and capture the output
          output = run_classification(script_path, uploaded_file)
          puts uploaded_file
          puts "ok"
          # Define a regular expression pattern to match the desired string
          puts output[60..-1]
          puts "ok"

          
          # Assuming you have some logic to handle the output
          # This could involve saving the output in a database or using it for further processing
          # For now, we'll just set it as a variable to be used in the template
          output = output[60..-1]
          # You can render the 'found.slim' template here
          view 'found', locals: { output:}
        end
      end


      routing.on 'missing' do
        # POST /adopt
        routing.post do
          # Perform any necessary processing for the 'Adopt?' button click
          # ...
    
          # Render the 'adopt.slim' file
          view 'missing'
    
          # Redirect to the desired page
        end
      end


  



    end
  end
end
