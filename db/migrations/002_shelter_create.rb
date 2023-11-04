# frozen_string_literal: true

require 'sequel'

Sequel.migration do
  change do
    create_table(:shelters) do
      primary_key :animal_shelter_pkid, null: false

      String :shelter_name, null: false
      String :shelter_address, null: false
      String :shelter_tel

      Integer :cat_number, null: false
      Integer :dog_number, null: false
      Integer :animal_number, null: false
      DateTime :created_at
      DateTime :updated_at
    end
  end
end
