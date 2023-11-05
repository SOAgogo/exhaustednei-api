# frozen_string_literal: true

require 'roda'
require 'slim'
require 'json'

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
            animal_place = routing.params['town'].downcase
            routing.redirect "project/#{animal_kind}/#{animal_place}"
          end
        end

        routing.on 'dog', String do |_suffix|
          routing.get do
            # GET /project/dog/{animal_home}
            # TODO: converrt the pkid to shelter name
            ShelterMapper.find_animal_in_shelter('臺北市', '狗')
            animal_pic = file.select { |ath| ath['animal_kind'] == '狗' }.map { |ath| ath['album_file'] }
            animal_dip = file.select { |ath| ath['animal_kind'] == '狗' }.map { |ath| ath['animal_place'] }

            view 'project', locals: { image_url: animal_pic.zip(animal_dip) }
          end
        end
        routing.on 'cat', String do |_suffix|
          # GET /project/cat/{animal_home}
          animal_pic = file.select { |ath| ath['animal_kind'] == '貓' }.map { |ath| ath['album_file'] }
          animal_dip = file.select { |ath| ath['animal_kind'] == '貓' }.map { |ath| ath['animal_place'] }

          view 'project', locals: { image_url: animal_pic.zip(animal_dip) }
        end
      end
    end
  end
end
