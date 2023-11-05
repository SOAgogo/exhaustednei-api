# frozen_string_literal: true

require 'roda'
require 'slim'
require 'json'
require 'uri'

module Info
  # Web App
  class App < Roda
    plugin :render, engine: 'slim', views: 'app/views'
    plugin :assets, css: 'style.css', path: 'app/views/assets'
    plugin :common_logger, $stderr
    plugin :halt
    plugin :json
    ans = File.read('spec/fixtures/DogCat_results.json')
    file = JSON.parse(ans)
    route do |routing|
      routing.assets # load CSS
      response['Content-Type'] = 'text/html; charset=utf-8'

      # GET /
      routing.root do
        random = rand(0..19)
        animal_pic = file[random]['album_file']
        view 'home', locals: { image_url: animal_pic }
      end

      routing.on 'project' do
        routing.is do
          # POST /project/
          routing.post do
            animal_kind = routing.params['animal_kind'].downcase
            shelter_name = routing.params['shelter_name']
            routing.redirect "project/#{animal_kind}/#{shelter_name}"
          end
        end

        routing.on String, String do |animal_kind, shelter_name|
          # GET /project/owner/project

          animal_kind == 'dog' ? animal_kind_ch = '狗' : animal_kind_ch = '貓' 
          animal_pic = file.select { |ath| (ath['animal_kind'] == animal_kind_ch) && (ath['shelter_name'] == URI.decode_www_form_component(shelter_name)
          )}
          .map { |ath| ath['album_file'] }
          animal_dip = file.select { |ath| (ath['animal_kind'] == animal_kind_ch) && (ath['shelter_name'] == URI.decode_www_form_component(shelter_name)
          )}
          .map { |ath| ath['animal_place'] }

          view 'project', locals: { image_url: animal_pic.zip(animal_dip) }
        end
      end
    end
  end
end