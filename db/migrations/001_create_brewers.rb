# frozen_string_literal: true

Sequel.migration do
  change do
    create_table(:brewers) do
      primary_key :id
      String :name, null: false, unique: true
    end
  end
end
