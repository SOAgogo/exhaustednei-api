# frozen_string_literal: true

require 'dry-validation'

module PetAdoption
  module Forms
    # Form validation for Github project URL
    class UserDataValidator < Dry::Validation::Contract
      params do
        required(:session_id).filled(:string)
        required(:firstname).filled(:string)
        required(:lastname).filled(:string)
        required(:email).filled
        required(:phone).filled
        required(:address).filled(:string)
        required(:state).filled(:string)
        required(:comment).filled(:string)
      end

      EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
      PHONE_REGEX_TAIWAN_MOBILE = /\A09\d{8}\z/ # Adjust this regex based on your phone number validation requirements

      rule(:email) do
        key.failure('must be a valid email address') unless value.match?(EMAIL_REGEX)
      end
      rule(:phone) do
        key.failure('must be a valid Taiwan mobile phone number') unless value.match?(PHONE_REGEX_TAIWAN_MOBILE)
      end

      rule(:address) do
        key.failure('must contain 縣(市)') unless value.match?(/[縣市]/)
        key.failure('must contain 鄉(鎮)(區)') unless value.match?(/[區鄉鎮]/)
        key.failure('must contain 路(街)') unless value.include?('路') || value.include?('街')
        key.failure('must contain 號') unless value.include?('號')
      end
      rule(:state) do
        unless value.include?('keeper') || value.include?('donater') || value.include?('adopter')
          key.failure('must be one of these three values: keeper,donater,adopter')
        end
      end
    end

    # Form validation for Github project URL
    class HumanReadAble
      def self.error(hash)
        string = ''
        hash.map do |key, list_value|
          string += "#{key} \t"
          string = HumanReadAble.error_message(list_value, string)
          string += ",\t"
        end
      end

      def self.error_message(list_value, string)
        list_value.map do |value|
          string += " #{value} \t"
        end
        string
      end
    end
  end
end
