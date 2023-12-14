# frozen_string_literal: true

require 'sequel'

Sequel.migration do
  change do
    create_table(:animals) do
      primary_key :id

      foreign_key :shelter_id, :shelters

      Integer :origin_id, unique: true, null: false
      String :species
      String :sex, null: false
      Boolean :sterilized
      Boolean :vaccinated
      String :bodytype
      String :color
      String :age
      String :image_url
      Time :registration_date, null: false
      Time :birth_date, null: true
      String :health_condition, null: true
      String :personality, null: true
      DateTime :created_at
      DateTime :updated_at
    end
  end
end
