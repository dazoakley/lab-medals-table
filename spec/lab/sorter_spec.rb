require 'spec_helper'

RSpec.describe LAB::Sorter do
  before do
    stub_database
  end

  let(:brewers) { LAB::Brewer.all }

  subject { described_class.new(brewers) }

  describe '#sort_and_rank' do
    it 'should rank the brewers correctly' do
      expected_ranks = [1, 2, 3, 4, 5, 6, 7, 8, 9, '=', '=', '=', '=', 14, '=', '=', '=', 18, '=', '=', '=']
      expect(subject.sort_and_rank.map { |elm| elm[1] }).to eq(expected_ranks)
    end
  end

  describe '#ranked_names' do
    it 'should sort the brewers into the correct order' do
      expected = ['Mark Sanderson', 'Dave Strachan', 'Phill Turner', 'Chris Pinnock', 'Ian Cosier', 'Lee Immins',
                  'Fraser Withers', 'Joell Leskin', 'Rob Gallagher', 'Guy Asaert', 'Serge Savin', 'Lucas Stolarczyk',
                  'Craig Tarft', 'Mick Harrison', 'Steve Smith', 'James Wilson', 'Simas Vainauskas', 'Charlie Cat',
                  'Russell Anthony', 'Richard Davies', 'Les Manley']

      expect(subject.ranked_names).to eq(expected)
    end
  end
end
