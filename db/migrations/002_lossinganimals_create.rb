# frozen_string_literal: true

require 'sequel'

Sequel.migration do
  change do
    create_table(:loss_animals) do
      primary_key :id

      String :name
      String :phone_number, null: false, unique: true
      String :user_email, unique: true
      String :county
      String :s3_image_url, null: false, unique: true
      Float :longtitude, null: false, unique: true
      Float :latitude, null: false, unique: true

      DateTime :created_at
      DateTime :updated_at
    end
  end
end