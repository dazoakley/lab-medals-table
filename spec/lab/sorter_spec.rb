require 'spec_helper'

RSpec.describe LAB::Sorter do
  subject { described_class.new(brewers) }

  let(:brewers) do
    {
      'A' => {
        'score' => 40,
        'bos' => {
          'gold' => [{}],
          'silver' => [{}, {}]
        }
      },
      'C' => {
        'score' => 20,
        'flight' => {
          'gold' => [{}, {}]
        }
      },
      'D' => {
        'score' => 20,
        'flight' => {
          'gold' => [{}, {}]
        }
      },
      'B' => {
        'score' => 20,
        'bos' => {
          'silver' => [{}, {}]
        }
      }
    }
  end

  describe '#sort_and_rank' do
    it 'should rank the brewers correctly' do
      expected_ranks = [1, 2, 3, '=']
      expect(subject.sort_and_rank.map { |elm| elm[1] }).to eq(expected_ranks)
    end
  end

  describe '#ranked_names' do
    it 'should sort the brewers into the correct order' do
      expected = %w[A B C D]
      expect(subject.ranked_names).to eq(expected)
    end
  end
end
