# frozen_string_literal: true


require 'open3'
require_relative '../lib/star_sign'

module PetAdoption
  module GptConversation
    # class Conversation`
    class Conversation
      attr_reader :messages

      def initialize(messages)
        @messages = messages
      end

      def generate_words
        @result = `python app/infrastructure/gateways/gpt_text.py "#{@messages}"`
        begin
          output = parse_the_word(@result)
          raise StandardError if output.nil?

          output[1]
        rescue StandardError
          'Sorry, I do not understand what you are saying.'
        end
      end

      def parse_the_word(result)
        result.match(/content='([^']+)'/)
      end
    end

    # class ImageConversation`
    class ImageConversation
      include StarSign::Predict
      def initialize(image_path)
        @image_path = image_path
      end

      def generate_words_from_image(birth_date)
        star_sign = which_star_sign(birth_date)
        @result = `python app/infrastructure/gateways/gpt_image.py "#{@image_path}" "#{star_sign}"`
      end
    end
  end
end
