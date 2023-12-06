require 'pry'
require 'open3'

module PetAdoption
  module GptConversation
    class Conversation
      def initialize(messages)
        @messages = messages
      end
      def generate_words
        @result = `python gpt.py "#{@messages}"`
      end

    end
  end
end
