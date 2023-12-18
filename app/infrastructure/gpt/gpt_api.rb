# frozen_string_literal: true

require 'open3'
require_relative '../lib/star_sign'
require 'pry'

module PetAdoption
  module GptConversation
    # class Conversation`
    class Conversation
      attr_reader :messages

      def initialize(messages)
        @messages = messages
      end

      def generate_words
        @result = `python app/infrastructure/gpt/gpt_text.py "#{@messages}"`
        # @result = `python gpt_text.py"#{@messages}"`
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
      def initialize
        @image_path = ''
      end

      def image_path(image_path)
        @image_path = image_path
      end

      def generate_words_by_star_sign(birth_date)
        star_sign = which_star_sign(birth_date)
        `python app/infrastructure/gpt/gpt_image.py "#{@image_path}" "#{star_sign}"`
        # `python gpt_image.py "#{@image_path}" "#{star_sign}"`
        # @result = `python gpt_image.py "#{@image_path}" "#{star_sign}"`
      end

      def generate_words_for_takecare_instructions
        `python app/infrastructure/gpt/gpt_image.py "#{@image_path}"`
        # @result = `python gpt_image.py "#{@image_path}"`
      end
    end

    # class ImageConparision
    class ImageComparision
      def initialize
        @image_path1 = ''
        @image_path2 = ''
      end

      def image_path(image_path1, image_path2)
        @image_path1 = image_path1
        @image_path2 = image_path2
      end

      def generate_similarity
        @result = `python app/infrastructure/gpt/gpt_image.py "#{@image_path1}" "#{@image_path2}"`
        # @result = `python gpt_image.py "#{@image_path1}" "#{@image_path2}"`
        if @result.match(/(\d+)%/)[1]
          @result.match(/(\d+)%/)[1].to_i / 100.0
        else
          0
        end
      end
    end
  end
end
