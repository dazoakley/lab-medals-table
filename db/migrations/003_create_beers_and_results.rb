# frozen_string_literal: true

Sequel.migration do
  change do
    create_table(:beers) do
      primary_key :id
      foreign_key :brewer_id, :brewers, null: false
      foreign_key :assistant_brewer_id, :brewers, null: true
      String :name, null: false
    end

    create_table(:results) do
      primary_key :id
      foreign_key :competition_edition_id, :competition_editions, null: false
      foreign_key :beer_id, :beers, null: false
      foreign_key :style_id, :styles, null: false
      String :round, null: false
      String :place, null: false
      unique %i[competition_edition_id beer_id round]
    end
  end
end
