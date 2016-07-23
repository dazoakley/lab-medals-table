require 'spec_helper'

RSpec.describe LAB::Sorter do
  subject { described_class.new(brewers) }

  let(:brewers) do
    {
      '1st place' => {
        'score' => 40,
        'bos'   => {
          'gold'   => [{}],
          'silver' => [{}, {}]
        }
      },
      '2nd place' => {
        'score' => 20,
        'bos'   => {
          'silver' => [{}, {}]
        }
      },
      '3rd place' => {
        'score'  => 20,
        'flight' => {
          'gold' => [{}, {}]
        }
      }
    }
  end

  describe '#ranked_names' do
    it 'should sort the brewers into the correct order' do
      expected = ['1st place', '2nd place', '3rd place']
      expect(subject.ranked_names).to eq(expected)
    end
  end
end
