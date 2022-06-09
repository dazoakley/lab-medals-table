# frozen_string_literal: true

Sequel.migration do
  change do
    alter_table(:competitions) do
      add_column :smaller_competition, TrueClass, default: false, null: false
    end
  end
end
