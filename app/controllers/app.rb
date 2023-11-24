# frozen_string_literal: true

require 'roda'
require 'slim'
require 'slim/include'
require 'json'
require 'uri'
require 'pry'
require 'securerandom'
require 'fileutils'
require 'open3'

module PetAdoption
  # Web App

  # for controller part
  class App < Roda
    plugin :halt
    plugin :flash
    plugin :all_verbs # allows HTTP verbs beyond GET/POST (e.g., DELETE)
    plugin :render, engine: 'slim', views: 'app/presentation/views_html'
    plugin :public, root: 'app/presentation/public'
    plugin :assets, path: 'app/presentation/assets',
                    css: 'style.css', js: 'popup.js'
    plugin :common_logger, $stderr
    plugin :json

    # use Rack::MethodOverride

    route do |routing|
      routing.assets # load CSS
      response['Content-Type'] = 'text/html; charset=utf-8'
      routing.public # load static files

      # GET /
      routing.root do
        session[:watching] ||= {}
        routing.redirect '/home' if session[:watching]['session_id']
        flash.now[:notice] = 'Welcome web page' unless session[:watching]['session_id']
        view('signup')
      end

      routing.post 'signup' do
        firstname = routing.params['first_name']
        lastname = routing.params['last_name']
        email = routing.params['email']
        phone = routing.params['phone']
        address = routing.params['address']
        willingness = routing.params['state']
        session_id = SecureRandom.uuid

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

        user = PetAdoption::Adopters::AccountMapper.new(cookie_hash).find

        db_user = Repository::Adopters::Users.new(
          user.to_attr_hash.merge(
            address: URI.decode_www_form_component(user.address)
          )
        ).create_user
        flash.now[:notice] = 'Your user creation failed...' if db_user.session_id.nil?
        session[:watching] = cookie_hash
        routing.redirect '/home'
      end

      routing.on 'home' do
        routing.is do
          begin
            animal_pic = Repository::Info::Animals.web_page_cover
          rescue StandardError => e
            App.logger.error e.backtrace.join("DB can't show COVER PAGE\n")
            flash[:error] = 'Could not find the cover page.'
          end
          view 'home', locals: { image_url: PetAdoption::Views::Picture.new(animal_pic).cover }
        end
      end

      routing.on 'animal' do
        routing.is do
          routing.post do
            begin
              animal_kind = routing.params['animal_kind'].downcase
              shelter_name = routing.params['shelter_name']
              if animal_kind != 'dog' && animal_kind != 'cat'
                flash[:error] = 'Please select animal kind correctly.'
                routing.redirect '/home'
              end
              if shelter_name.nil?
                flash[:error] = 'Dont leave shelter name blank.'
                routing.redirect '/home'
              end
              sn_ch = URI.decode_www_form_component(shelter_name)
            end
            routing.redirect "animal/#{animal_kind}/#{sn_ch}"
          end
        end

        routing.on String, String do |animal_kind, shelter_name|
          ak_ch = animal_kind == 'dog' ? '狗' : '貓'
          shelter_name = URI.decode_www_form_component(shelter_name)
          animal_kind = URI.decode_www_form_component(ak_ch)
          begin
            animal_obj_list = Repository::Info::Animals.select_animal_by_shelter_name(animal_kind, shelter_name)
            view_obj = PetAdoption::Views::ChineseWordsCanBeEncoded.new(animal_obj_list)

            view 'project', locals: {
              view_obj:
            }
          rescue StandardError => e
            App.logger.error e.backtrace.join("DB can't find the results\n")
            flash[:error] = 'Could not find the results.'
            routing.redirect '/home'
          end
        end
      end

      routing.on 'user/add-favorite-list', String do |animal_id|
        animal_obj_list = Repository::Adopters::Users.get_animal_favorite_list_by_user(
          session[:watching]['session_id'], animal_id
        )
        # don't store animal_obj_list to cookies, it's too big
        session[:watching]['animal_obj_list'] = animal_obj_list

        view_obj = PetAdoption::Views::ChineseWordsCanBeEncoded.new(animal_obj_list)
        routing.is do
          view 'favorite', locals: {
            view_obj:
          }
        end
      end

      routing.on 'user/favorite-list' do
        routing.is do
          animal_obj_list = session[:watching]['animal_obj_list']
          view_obj = PetAdoption::Views::ChineseWordsCanBeEncoded.new(animal_obj_list)
          view 'favorite', locals: {
            view_obj:
          }
        end
      end

      routing.on 'next-keeper' do
        routing.is do
          view 'next-keeper'
        end
      end

      routing.on 'adopt' do
        routing.post do
          view 'adopt'
        end
      end

      routing.on 'found' do
        routing.post do
          # script_path = 'app/controllers/classification.py'
          uploaded_file = routing.params['file0'][:tempfile].path if routing.params['file0'].is_a?(Hash)

          output, = PetAdoption::ImageRecognition::Classification.new(uploaded_file).run

          view 'found', locals: { output: PetAdoption::Views::ImageRecognition.new(output)}
        end
      end

      routing.on 'missing' do
        routing.post do
          view 'missing'
        end
      end
    end
  end
end
