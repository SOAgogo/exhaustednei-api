# frozen_string_literal: true

require 'roda'
require 'slim'
require 'slim/include'
require 'json'
require 'uri'
require 'securerandom'
require 'fileutils'
require 'open3'

module PetAdoption
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
        session_id = SecureRandom.uuid
        routing.params.merge!('session_id' => session_id)
        url_request = Forms::UserDataValidator.new.call(routing.params.transform_keys(&:to_sym))
        if url_request.failure?
          session[:watching] = {}
          flash[:error] = Forms::HumanReadAble.error(url_request.errors.to_h)
          routing.redirect '/'
        end

        # for domain testing
        Services::TestForDomain.new.call(cookie_hash = routing.params)
        db_user = Services::CreateUserAccounts.new.call(url_request:)

        flash.now[:notice] = 'Your user creation failed...' if db_user.failure?
        session[:watching] = routing.params
        routing.redirect '/home'
      end

      routing.on 'home' do
        routing.is do
          animal_pic = Services::PickAnimalCover.new.call
          cover_page = PetAdoption::Views::Picture.new(animal_pic.value![:cover]).cover
          view 'home', locals: { image_url: cover_page }
        rescue StandardError => e
          App.logger.error e.backtrace.join("DB can't show COVER PAGE\n")
          flash[:error] = 'Could not find the cover page.'
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
            response = Services::SelectAnimal.new.call({ animal_kind:, shelter_name: })
            view_obj = PetAdoption::Views::ChineseWordsCanBeEncoded.new(response.value![:animal_obj_list])

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
        animal_obj_list = PetAdoption::Services::FavoriteListUser.new.call({
                                                                             session_id: session[:watching]['session_id'], animal_id:
                                                                           })
        # don't store animal_obj_list to cookies, it's too big
        session[:watching]['animal_obj_list'] = animal_obj_list.value![:animals]

        view_obj = PetAdoption::Views::ChineseWordsCanBeEncoded.new(animal_obj_list.value![:animals])
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
          uploaded_file = routing.params['file0'][:tempfile].path if routing.params['file0'].is_a?(Hash)
          if uploaded_file.nil?
            view 'found', locals: { output: nil }
          else
            output = Services::ImageRecognition.new.call({ uploaded_file: })
            if output.failure?
              flash[:error] = 'No recognition output, please try again.'
              routing.redirect '/found'
            end
            output_view = PetAdoption::Views::ImageRecognition.new(output.value![:output])
            view 'found', locals: { output: output_view }
          end
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
