# frozen_string_literal: true

require 'open3'

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
      def initialize
        @image_path = ''
      end

      def image_path(image_path)
        @image_path = image_path
      end

      def generate_words_for_takecare_instructions
        `python app/infrastructure/gpt/gpt_image.py "#{@image_path}"`
      end
    end

    # class ImageConparision
    class SpeicesIndentifier
      attr_reader :species

      def initialize
        @species = ''
      end

      def run(url)
        @result = `python app/infrastructure/gpt/gpt_species.py "#{url}" `
        # @result = `python gpt_species.py "#{@image_path1}" `
        # match = @result.match(/[A-Z][a-z]+(?=\s[A-Z])(?:\s[A-Z][a-z]+)+/)
        match = @result.match(/content='([^']+)'/)

        @species = if match
                     match[1]
                   else
                     'hybrid'
                   end
      end
    end
  end
end
