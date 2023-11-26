# frozen_string_literal: true

module PetAdoption
  module Services
    # class TestForDomain`
    class TestForDomain
      include Dry::Transaction

      step :test_for_cookies

      private

      def test_for_cookies(input)
        return Success('no testing') unless ENV['testing'] == 'true'

        begin
          open('spec/testing_cookies/user_input.json', 'w') do |file|
            file << input[:cookie_hash].to_json
          end
          Success('successfully testing')
        rescue StandardError => e
          Failure(e.message)
        end
      end
    end
  end
end
