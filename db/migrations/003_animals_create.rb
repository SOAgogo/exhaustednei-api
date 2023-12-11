# frozen_string_literal: true

require 'sequel'

Sequel.migration do
  change do
    create_table(:animals) do
      primary_key :id

      foreign_key :shelter_id, :shelters
      foreign_key :users_id, :users

      Integer :remote_id, unique: true, null: false
      String :species
      String :sex, null: false
      Boolean :sterilized
      Boolean :vaccinated
      String :bodytype
      String :color
      String :age
      String :image_url
      Time :registration_date, null: false

      Time :birth_date
      String :health_condition
      String :personality
      DateTime :created_at
      DateTime :updated_at
    end
  end
end
