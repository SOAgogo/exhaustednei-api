# frozen_string_literal: true

require 'sequel'

Sequel.migration do
  change do
    create_table(:shelter) do
      primary_key :id

      Integer     :animal_id, unique: true

      String :animal_shelter_pkid, null: false
      String :shelter_name, null: false
      String :shelter_address, null: false
      Boolean :shelter_tel
      Boolean :animal_bacterin

      Integer :cat_number, null: false
      Integer :dog_number, null: false
      Integer :animal_number, null: false
      DateTime :created_at
      DateTime :updated_at
    end
  end
end
