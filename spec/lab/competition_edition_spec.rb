# frozen_string_literal: true

require 'spec_helper'

RSpec.describe LAB::CompetitionEdition do
  before do
    stub_database
  end

  describe '#points_eligible?' do
    it 'returns true if the competition is eligible for point' do
      no_points_ce = LAB::Competition.find(name: 'London vs Leeds New England IPA Challenge').competition_editions.first
      points_ce = LAB::Competition.find(name: 'Lager Than Life').competition_editions.first

      expect(no_points_ce.points_eligible?).to be false
      expect(points_ce.points_eligible?).to be true
    end
  end

  describe '#smaller_competition?' do
    it 'returns true if the competition is a smaller competition' do
      lager_comp = LAB::Competition.find(name: 'Lager Than Life').competition_editions.first
      smaller_comp = LAB::Competition.find(name: 'Bexley Festival').competition_editions.first

      expect(lager_comp.smaller_competition?).to be false
      expect(smaller_comp.smaller_competition?).to be true
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

  describe '#winning_brewers' do
    it 'returns all winning brewers (LAB::Brewer\'s) for the competition edition' do
      competition_edition = LAB::Competition.find(name: 'Lager Than Life').competition_editions.min_by(&:date)

      expect(competition_edition.winning_brewers.count).to eq(7)
      expect(competition_edition.winning_brewers.map(&:name).sort).to eq([
                                                                           'Dave Strachan',
                                                                           'Fraser Withers',
                                                                           'Lee Immins',
                                                                           'Lucas Stolarczyk',
                                                                           'Mark Sanderson',
                                                                           'Russell Anthony',
                                                                           'Steve Smith'
                                                                         ])
    end
  end
end
