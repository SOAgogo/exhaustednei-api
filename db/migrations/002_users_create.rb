# frozen_string_literal: true

require 'sequel'

Sequel.migration do
  change do
    create_table(:users) do
      primary_key :id

      String :session_id, unique: true, null: false
      String :firstname, null: false
      String :lastname, null: false
      String :phone
      String :email
      String :address
      Integer :donate_money
      DateTime :created_at
      DateTime :updated_at
    end
  end
end
