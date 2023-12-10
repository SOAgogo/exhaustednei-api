# frozen_string_literal: true

require 'sequel'

Sequel.migration do
  change do
    create_table(:shelters) do
      primary_key :id

      Integer :orgin_id, unique: true, null: false
      String :name, null: false
      String :address, null: false
      String :phone_number
      Integer :cat_number, null: false
      Integer :dog_number, null: false
      Integer :donate_money, null: false
      DateTime :created_at
      DateTime :updated_at
    end
  end
end
