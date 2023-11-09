# frozen_string_literal: true

require 'uri'
# create a chinese decoder
module PetAdoption
  # Decode Chinese
  module Decoder
    def decode_chinese(obj)
      obj.map do |key, value|
        obj[key] = URI.decode_www_form_component(value)
      end
    end
  end
end
