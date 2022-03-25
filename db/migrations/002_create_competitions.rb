# frozen_string_literal: true

Sequel.migration do
  change do
    create_table(:competitions) do
      primary_key :id
      String :name, null: false, unique: true
      String :abbreviated_name, null: false, unique: true
    end

    create_table(:guidelines) do
      primary_key :id
      String :name, null: false, unique: true
    end

    create_table(:styles) do
      primary_key :id
      foreign_key :guideline_id, :guidelines, null: false
      String :number, null: false
      String :name, null: false
      unique [:guideline_id, :number]
    end

    create_table(:locations) do
      primary_key :id
      String :name, null: false, unique: true
    end

    create_table(:competition_editions) do
      primary_key :id
      foreign_key :competition_id, :competitions, null: false
      foreign_key :guideline_id, :guidelines, null: false
      foreign_key :location_id, :locations, null: false
      Date :date, null: false
    end
  end
end
