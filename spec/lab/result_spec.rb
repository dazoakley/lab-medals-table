# frozen_string_literal: true

require 'spec_helper'

RSpec.describe LAB::Result do
  let(:guideline) { LAB::Guideline.create(name: 'Test Guideline') }
  let(:style) { LAB::Style.create(guideline_id: guideline.id, name: 'Test Style', number: '1A') }
  let(:brewer) { LAB::Brewer.create(name: 'Test Brewer') }
  let(:beer) { LAB::Beer.create(name: 'Test Beer', brewer_id: brewer.id) }
  let(:competition) { LAB::Competition.create(name: 'Test Competition', abbreviated_name: 'Test') }
  let(:location) { LAB::Location.create(name: 'Test Location') }
  let(:edition) do
    LAB::CompetitionEdition.create(competition_id: competition.id, date: Date.today, guideline_id: guideline.id,
                                   location_id: location.id)
  end

  describe '#description_for_roll_of_honour' do
    it 'returns the correct description' do
      result1 = LAB::Result.create(round: 'flight', place: 'gold', competition_edition_id: edition.id,
                                   beer_id: beer.id, style_id: style.id)
      expected1 = 'Gold - Test Brewer - Test Beer (1A: Test Style)'

      expect(result1.description_for_roll_of_honour).to eq(expected1)

      beer2 = LAB::Beer.create(name: 'Test Beer 2', brewer_id: brewer.id, assistant_brewer_id: brewer.id)
      style2 = LAB::Style.create(guideline_id: guideline.id, number: 'NONE')
      result2 = LAB::Result.create(round: 'flight', place: 'silver', competition_edition_id: edition.id,
                                   beer_id: beer2.id, style_id: style2.id)
      expected2 = 'Silver - Test Brewer (Assistant Brewer: Test Brewer) - Test Beer 2'

      expect(result2.description_for_roll_of_honour).to eq(expected2)
    end
  end

  describe '#score' do
    describe 'when the competition is points eligible' do
      describe 'when the result is a "flight" round' do
        let(:result) do
          LAB::Result.create(round: 'flight', place: 'gold', competition_edition_id: edition.id, beer_id: beer.id,
                             style_id: style.id)
        end

        it 'returns the correct score for a gold medal' do
          result.place = 'gold'
          expect(result.score).to eq 10
        end

        it 'returns the correct score for a silver medal' do
          result.place = 'silver'
          expect(result.score).to eq 5
        end

        it 'returns the correct score for a bronze medal' do
          result.place = 'bronze'
          expect(result.score).to eq 2.5
        end

        it 'returns no score for a 4th place' do
          result.place = '4th'
          expect(result.score).to eq 0
        end

        it 'returns no score for a HM' do
          result.place = 'HM'
          expect(result.score).to eq 0
        end
      end

      describe 'when the result is a "bos" round' do
        let(:result) do
          LAB::Result.create(round: 'bos', place: 'gold', competition_edition_id: edition.id, beer_id: beer.id,
                             style_id: style.id)
        end

        it 'returns the correct score for a gold medal' do
          result.place = 'gold'
          expect(result.score).to eq 20
        end

        it 'returns the correct score for a silver medal' do
          result.place = 'silver'
          expect(result.score).to eq 10
        end

        it 'returns the correct score for a bronze medal' do
          result.place = 'bronze'
          expect(result.score).to eq 5
        end

        it 'returns no score for a 4th place' do
          result.place = '4th'
          expect(result.score).to eq 0
        end

        it 'returns no score for a HM' do
          result.place = 'HM'
          expect(result.score).to eq 0
        end
      end
    end

    describe 'when the competition is NOT points eligible' do
      let(:competition) do
        LAB::Competition.create(name: 'Test Competition', abbreviated_name: 'Test', points_eligible: false)
      end
      let(:result) do
        LAB::Result.create(round: 'bos', place: 'gold', competition_edition_id: edition.id, beer_id: beer.id,
                           style_id: style.id)
      end

      it 'returns no score regardless the medal' do
        LAB::Result.rounds.each do |round|
          LAB::Result.gold_silver_bronze_places.each do |place|
            result.round = round
            result.place = place
            expect(result.score).to eq 0
          end
        end
      end
    end
  end

  describe '.best_of_show_results_for_competition_edition' do
    before do
      stub_database
    end

    it 'returns BoS results for the given competiton edition' do
      ltl = LAB::Competition.find(name: 'Lager Than Life').competition_editions.max_by(&:date)
      nawb = LAB::Competition.find(name: 'NAWB National').competition_editions.first

      expect(described_class.best_of_show_results_for_competition_edition(ltl).count).to eq(1)
      expect(described_class.best_of_show_results_for_competition_edition(nawb).count).to eq(0)
    end

    it 'returns BoS results for the given competiton edition sorted by medal' do
      ltl = LAB::Competition.find(name: 'Lager Than Life').competition_editions.min_by(&:date)

      results = described_class.best_of_show_results_for_competition_edition(ltl)

      expect(results.count).to eq(2)
      expect(results.map(&:place)).to eq(%w[gold bronze])
    end
  end

  describe '.flight_results_for_competition_edition' do
    before do
      stub_database
    end

    it 'returns flight results for the given competiton edition' do
      ltl = LAB::Competition.find(name: 'Lager Than Life').competition_editions.max_by(&:date)
      nawb = LAB::Competition.find(name: 'NAWB National').competition_editions.first

      expect(described_class.flight_results_for_competition_edition(ltl).count).to eq(6)
      expect(described_class.flight_results_for_competition_edition(nawb).count).to eq(9)
    end

    it 'returns flight results for the given competiton edition sorted by medal' do
      ltl = LAB::Competition.find(name: 'Lager Than Life').competition_editions.max_by(&:date)

      results = described_class.flight_results_for_competition_edition(ltl)

      expect(results.count).to eq(6)
      expect(results.map(&:place)).to eq(%w[gold gold silver silver silver bronze])
    end
  end
end
