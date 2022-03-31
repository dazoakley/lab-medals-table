# frozen_string_literal: true

require 'spec_helper'

RSpec.describe LAB::CompetitionEdition do
  before do
    stub_database
  end

  # competition = LAB::Competition.find(name: 'Lager Than Life')
  # competition_edition = competition.competition_editions.max_by(&:date)

  describe '.points_eligible' do
    it 'returns all points eligible competition editions' do
      expect(LAB::CompetitionEdition.points_eligible.count).to eq(5)

      competition_names = LAB::CompetitionEdition.points_eligible.map(&:competition).map(&:name)

      expect(competition_names).to_not include('London vs Leeds New England IPA Challenge')
    end
  end

  describe '#best_of_show_winners?' do
    it 'returns true if there are any best of show winners' do
      competition_edition = LAB::Competition.find(name: 'Lager Than Life').competition_editions.max_by(&:date)

      expect(competition_edition.best_of_show_winners?).to eq(true)
    end

    it 'returns false if there are no best of show winners' do
      competition_edition = LAB::Competition.find(name: 'NAWB National').competition_editions.first

      expect(competition_edition.best_of_show_winners?).to eq(false)
    end
  end

  describe '#best_of_show_winners' do
    it 'returns all best of show winners (LAB::Result\'s)' do
      competition_edition = LAB::Competition.find(name: 'Lager Than Life').competition_editions.max_by(&:date)

      expect(competition_edition.best_of_show_winners.count).to eq(1)
    end
  end

  describe '#flight_winners?' do
    it 'returns true if there are any flight winners' do
      competition_edition = LAB::Competition.find(name: 'Lager Than Life').competition_editions.max_by(&:date)

      expect(competition_edition.flight_winners?).to eq(true)
    end

    it 'returns false if there are no flight winners' do
      competition_edition = LAB::Competition.find(abbreviated_name: 'London vs Leeds').competition_editions.first

      expect(competition_edition.flight_winners?).to eq(false)
    end
  end

  describe '#flight_winners' do
    it 'returns all flight winners (LAB::Result\'s)' do
      competition_edition = LAB::Competition.find(name: 'Lager Than Life').competition_editions.max_by(&:date)

      expect(competition_edition.flight_winners.count).to eq(6)
    end
  end
end
