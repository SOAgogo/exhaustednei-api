# frozen_string_literal: true

require 'roda'
require 'slim'
require 'json'
require 'uri'
require 'pry'

module PetAdoption
  # Web App
  class App < Roda
    plugin :render, engine: 'slim', views: 'app/views'
    plugin :assets, css: 'style.css', path: 'app/views/assets'
    plugin :common_logger, $stderr
    plugin :halt
    plugin :json

    route do |routing|
      routing.assets # load CSS
      response['Content-Type'] = 'text/html; charset=utf-8'

      # GET /
      routing.root do
        animal_pic = Repository::Info::Animals.web_page_cover
        view 'home', locals: { image_url: animal_pic }
      end

      routing.on 'animal' do
        routing.is do
          # POST /project/
          routing.post do
            animal_kind = routing.params['animal_kind'].downcase
            shelter_name = routing.params['shelter_name']

            routing.redirect "animal/#{shelter_name}/#{animal_kind}"
          end
        end

        routing.on String, String do |shelter_name, animal_kind|
          # GET /project/owner/project
          ak_ch = animal_kind == 'dog' ? '狗' : '貓'
          animal_obj_hash = Repository::Info::Animals.select_animal_by_shelter_name(ak_ch, shelter_name)

          animal_obj_list = []
          animal_obj_hash.each do |_, animal_obj|
            animal_obj_list << animal_obj
          end

          view 'project', locals: {
            shelter_name: URI.decode_www_form_component(shelter_name),
            animal_kind: URI.decode_www_form_component(ak_ch),
            # image_url: animal_pic.zip(animal_id, animal_age, animal_colour,
            #                           animal_sex, animal_sterilization,
            #                           animal_bacterin, animal_bodytype,
            #                           album_place, animal_opendate),
            animal_obj_list:
          }
        end
      end
    end
  end
end
