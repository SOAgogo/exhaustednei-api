# frozen_string_literal: true

require 'sequel'

Sequel.migration do
  change do
    create_table(:shelter) do
      primary_key :id
      foreign_key :project_id, :dog
      foreign_key :project_id, :cat

      Integer     :animal_shelter_pkid, unique: true
      String      :shelter_name
      String      :shelter_address
      String      :shelter_tel
      Integer     :cat_number
      Integer     :dog_number
      Integer     :animal_number

      Hash.map(Strict::Integer, Animal) animal_object_list

      DateTime :created_at
      DateTime :updated_at
    end
  end
end