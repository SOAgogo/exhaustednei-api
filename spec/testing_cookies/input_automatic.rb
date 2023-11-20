# frozen_string_literal: true

require 'securerandom'
require 'json'
begin
  session_id = SecureRandom.uuid
  age = gets.chomp
  email = gets.chomp
  phone = gets.chomp
  address = gets.chomp
  willingness = gets.chomp
  insert_hash = {
    session_id:,
    age:,
    email:,
    phone:,
    address:,
    willingness:
  }
  open('spec/testing_cookies/user_input.json', 'w') do |f|
    f << insert_hash.to_json
  end
end
