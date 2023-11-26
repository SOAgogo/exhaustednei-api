# frozen_string_literal: true

require_relative '../layers/spec_helper'
require_relative '../../../helpers/database_helper'
require 'securerandom'

describe 'Crete User Service Integration Test' do
  describe 'create user in db and get the favorite list of the user' do
    it 'HAPPY: should return correct user input data and store that data in db' do
      # GIVEN: a valid project exists locally and is being watched
      fake_input_data = {
        'session_id' => SecureRandom.uuid,
        'firstname' => 'test',
        'lastname' => 'tony',
        'phone' => '09345678912',
        'email' => 'a1234@gmail.com',
        'address' => 'Taipei',
        'donate_money' => '1000'
      }

      # WHEN: we request a list of all watched projects
      result = CodePraise::Service::ListProjects.new.call(fake_input_data)

      db_user = result.value![:db_user]
      # THEN: we should see our project in the resulting list
      _(db_user['session_id']).must_equal fake_input_data['session_id']
      _(db_user['firstname']).must_equal fake_input_data['firstname']
      _(db_user['lastname']).must_equal fake_input_data['lastname']
      _(db_user['phone']).must_equal fake_input_data['phone']
      _(db_user['email']).must_equal fake_input_data['email']
      _(db_user['address']).must_equal fake_input_data['address']
      _(db_user['donate_money']).must_equal fake_input_data['donate_money']
    end
  end
end
