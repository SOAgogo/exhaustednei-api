# frozen_string_literal: true

require 'sequel'

Sequel.migration do
  change do
    create_table(:animals) do
      primary_key :id

      foreign_key :shelter_id, :shelters

      Integer :animal_id, unique: true, null: false
      String :animal_kind, null: false
      String :animal_variate
      String :animal_sex, null: false
      Boolean :animal_sterilization
      Boolean :animal_bacterin
      String :animal_bodytype
      String :animal_color
      String :animal_age
      String :animal_found_place
      String :album_file
      String :animal_place, null: false
      String :animal_opendate
      DateTime :created_at
      DateTime :updated_at
    end
  end
end
