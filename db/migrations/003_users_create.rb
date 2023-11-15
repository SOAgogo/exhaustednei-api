# frozen_string_literal: true

require 'sequel'

Sequel.migration do
  change do
    create_table(:users) do
      primary_key :id

      foreign_key :animal_id, :animals

      String :session_id, unique: true, null: false
      String :firstname, null: false
      String :lastname, null: false
      String :phone
      String :email

      DateTime :created_at
      DateTime :updated_at
    end
  end
end
