# frozen_string_literal: true

require 'spec_helper'

RSpec.describe LAB::Brewer do
  before do
    stub_database
  end

  describe '#results' do
    it 'returns the competition results for the brewer' do
      expect(LAB::Brewer.find(name: 'Charlie Cat').results.count).to eq(0)
      expect(LAB::Brewer.find(name: 'Mick Harrison').results.count).to eq(1)
      expect(LAB::Brewer.find(name: 'Ian Cosier').results.count).to eq(4)
    end
  end

  describe '#total_points' do
    it 'returns the total points for a brewers winning beers' do
      expect(LAB::Brewer.find(name: 'Ian Cosier').total_points).to eq 20
      expect(LAB::Brewer.find(name: 'Mark Sanderson').total_points).to eq 65
      expect(LAB::Brewer.find(name: 'Steve Smith').total_points).to eq 2.5
    end
  end

  describe '#total_medals' do
    it 'returns the total medal count for a brewers winning beers' do
      expect(LAB::Brewer.find(name: 'Ian Cosier').total_medals).to eq 3
      expect(LAB::Brewer.find(name: 'Mark Sanderson').total_medals).to eq 7
      expect(LAB::Brewer.find(name: 'Steve Smith').total_medals).to eq 1
    end
  end

  describe '#total_points_for_competition_edition' do
    it 'returns the total points for a brewers winning beers in a competition edition' do
      brewer = LAB::Brewer.find(name: 'Ian Cosier')
      competition = LAB::Competition.find(name: 'Lager Than Life')
      competition_edition = competition.competition_editions.max_by(&:date)

      expect(brewer.total_points_for_competition_edition(competition_edition)).to eq 15

      brewer = LAB::Brewer.find(name: 'Mark Sanderson')
      competition = LAB::Competition.find(name: 'Bexley Festival')
      competition_edition = competition.competition_editions.max_by(&:date)

      expect(brewer.total_points_for_competition_edition(competition_edition)).to eq 50
    end
  end

  describe '#medal_counts' do
    it 'returns the medal counts for a brewers winning beers' do
      expect(LAB::Brewer.find(name: 'Mark Sanderson').medal_counts)
        .to eq({
                 'bos' => { 'gold' => 1, 'silver' => 0, 'bronze' => 0, '4th' => 0, 'HM' => 0 },
                 'flight' => { 'gold' => 4, 'silver' => 0, 'bronze' => 2, '4th' => 0, 'HM' => 0 }
               })
    end
  end

  describe '#medal_counts_for_competition_edition' do
    it 'returns the medal counts for a brewers winning beers for a competition edition' do
      brewer = LAB::Brewer.find(name: 'Ian Cosier')
      competition = LAB::Competition.find(name: 'Lager Than Life')
      competition_edition = competition.competition_editions.max_by(&:date)

      expect(brewer.medal_counts_for_competition_edition(competition_edition))
        .to eq({
                 'bos' => { 'gold' => 0, 'silver' => 0, 'bronze' => 1, '4th' => 0, 'HM' => 0 },
                 'flight' => { 'gold' => 1, 'silver' => 0, 'bronze' => 0, '4th' => 0, 'HM' => 0 }
               })
    end
  end

  describe '#sorter_val' do
    it 'returns an array used for sorting and ranking brewers' do
      expect(LAB::Brewer.find(name: 'Mark Sanderson').sorter)
        .to eq(
          [65, 1, 0, 0, 4, 0, 2]
        )
    end
  end
end
