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
            sn_ch = URI.decode_www_form_component(shelter_name)

            routing.redirect "animal/#{animal_kind}/#{sn_ch}"
          end
        end

        routing.on String, String do |animal_kind, shelter_name|
          # GET /project/owner/project
          sn_ch = URI.decode_www_form_component(shelter_name)
          ak_ch = animal_kind == 'dog' ? '狗' : '貓'
          animal_obj_hash = Repository::Info::Animals.select_animal_by_shelter_name(ak_ch, sn_ch)

          animal_obj_list = []
          animal_obj_hash.each do |_, animal_obj|
            animal_obj_list << animal_obj
          end

          # animal_number = Repository::Info::Shelters.get_shelter_animal_number(shelter_name)
          # shelter_obj = Repository::Info::Shelters.find_shelter_by_name(shelter_name.to_s)
          # animal_num = shelter_obj.cat_number if animal_kind == 'cat'
          # animal_num = shelter_obj.dog_number if animal_kind == 'dog'

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
