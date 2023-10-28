# frozen_string_literal: true

def require_app
  Dir.glob('./lib/**/*.rb').each do |file|
    require file
  end
  Dir.glob('./lib/util.rb').each do |file|
    require file
  end
end
