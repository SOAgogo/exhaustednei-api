# frozen_string_literal: true

require 'pry'
require 'open3'
require '../lib/star_sign'

module PetAdoption
  module GptConversation
    # class Conversation`
    class Conversation
      def initialize(messages)
        @messages = messages
      end

      def generate_words
        @result = `python gpt_text.py "#{@messages}"`
      end
    end

    # class ImageConversation`
    class ImageConversation
      include StarSign
      def initialize(image_path)
        @image_path = image_path
      end

      def generate_words_from_image(birth_date)
        star_sign = which_star_sign(birth_date)
        @result = `python gpt_image.py "#{@image_path}" "#{star_sign}"`
      end
    end
  end
end
