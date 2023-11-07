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
          sn_ch = URI.decode_www_form_component(shelter_name)
          ak_ch = animal_kind == 'dog' ? '狗' : '貓'
          animal_info = file.select { |ath| ath['animal_kind'] == ak_ch && ath['shelter_name'] == sn_ch }
          animal_pic = animal_info.map { |ath| ath['album_file'] }
          animal_id = animal_info.map { |ath| ath['animal_id'] }
          animal_age = animal_info.map { |ath| ath['animal_age'] }
          animal_colour = animal_info.map { |ath| ath['animal_colour'] }

          view 'project', locals: {
            shelter_name: URI.decode_www_form_component(shelter_name),
            image_url: animal_pic.zip(animal_id, animal_age, animal_colour),
            animal_num: animal_pic.length,
            animal_kind:
          }
        end
      end
    end
  end
end
