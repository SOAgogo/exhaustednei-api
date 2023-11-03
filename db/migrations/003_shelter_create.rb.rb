# frozen_string_literal: true

require 'sequel'

Sequel.migration do
  change do
    create_table(:shelter) do
      primary_key :id

      foreign_key :dog_id, :dog
      foreign_key :cat_id, :cat

      add_foreign_key [:dog_id, :cat_id], :dog, :cat, name: :animal_object_list
      Integer :animal_shelter_pkid, unique: true
      String :shelter_name
      String :shelter_address
      String :shelter_tel
      Integer :cat_number
      Integer :dog_number
      Integer :animal_number

      DateTime :created_at
      DateTime :updated_at
    end

  end
end
