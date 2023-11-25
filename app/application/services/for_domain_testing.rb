# frozen_string_literal: true

module PetAdoption
  module Services
    # class TestForDomain`
    class TestForDomain
      def initialize(cookie_hash)
        @cookie_hash = cookie_hash
      end

      def call
        return unless ENV['testing'] == 'true'

        open('spec/testing_cookies/user_input.json', 'w') do |file|
          file << @cookie_hash.to_json
        end
      end
    end
  end
end
