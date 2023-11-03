Sequel.migration do
    change do
        create_table(:dog) do
            primary_key :id
            Integer :animal_id, unique: true
            String :animal_variate, album_file, unique: true, null: false
            String :animal_kind, animal_sex, animal_bodytype
            Bool : animal_sterilization, animal_bacterin

            DateTime :created_at
            DateTime :updated_at
        end
    end
end