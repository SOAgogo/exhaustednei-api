# frozen_string_literal: true

require 'roda'
require 'slim'
require 'json'

module EAS
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
        ans = File.read('spec/fixtures/DogCat_results.json')
        file = JSON.parse(ans)
        random = rand(0..19)
        animal_pic = file[random]['album_file']
        view 'home', locals: { image_url: animal_pic }

      end

      routing.on 'project' do
        routing.is do
          # POST /project/
          routing.post do
            animal_kind = routing.params['animal_kind']
            routing.redirect "animal_kind/"
          end
        end

        routing.on "animal_kind/" do 
          # GET /project/owner/project
          routing.post  do
            if animal_kind == "dog" 
              animal_kind = "狗"
            else
              animal_kind = "貓"
            end
            animal_kind_select =  file.select { |n| n['animal_kind'] == animal_kind }
            view 'project', locals: { json_data: animal_kind_select }
          end
        end
      end
    end
  end
end
