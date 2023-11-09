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

        routing.on String, String do |animal_kind, sn_ch|
          # GET /project/owner/project
          ak_ch = animal_kind == 'dog' ? '狗' : '貓'
          animal_obj_list = Repository::Info::Animals.select_animal_by_shelter_name(animal_kind, sn_ch)

          # shelter_obj = Repository::Info::Shelters.find_shelter_by_name(shelter_name)


          animal_pic = animal_obj_list.map { |ath| ath.album_file }
          animal_id = animal_obj_list.map { |ath| ath.animal_id }
          animal_age = animal_obj_list.map { |ath| ath.animal_age }
          animal_colour = animal_obj_list.map { |ath| ath.animal_colour }
          animal_sex = animal_obj_list.map {|ath| ath.animal_sex}
          animal_sterilization = animal_obj_list.map {|ath| ath.animal_sterilization}
          animal_bacterin = animal_obj_list.map {|ath| ath.animal_bacterin}
          animal_bodytype = animal_obj_list.map {|ath| ath.animal_bodytype}
          album_place = animal_obj_list.map {|ath| ath.album_place}
          animal_opendate = animal_obj_list.map {|ath| ath.animal_opendate}

          binding.pry
          puts animal_opendate
          view 'project', locals: {
            shelter_name: sn_ch,
            image_url: animal_pic.zip(animal_id, animal_age, animal_colour,
            animal_sex, animal_sterilization, 
            animal_bacterin, animal_bodytype, 
            album_place, animal_opendate
            ),
            #animal_num: shelter_obj.animal_nums,
            animal_num: '0',

            animal_kind: animal_kind
          }
        end
      end
    end
  end
end
