require 'spec_helper'

RSpec.describe LAB::CompetitionRollOfHonourBuilder do
  subject { described_class.new(comp) }

  let(:comp) do
    file = File.join(
      File.dirname(__FILE__), '..', '..',
      'data', '2016-brew-brighton.yaml'
    )

    YAML.load(File.read(file))
  end

  describe '#best_of_show_winners' do
    it 'extracts the best of show winners' do
      result = subject.best_of_show_winners

      expected = {
        '1st'   => {
          'brewer' => 'Phill Turner',
          'beer' => {
            'name'  => 'Georgijs Voshington Porter',
            'style' => '20A'
          }
        },
        '3rd' => {
          'brewer' => 'Mike Carter',
          'beer' => {
            'name'  => 'Dead Fly In The Wax',
            'style' => '22C'
          }
        }
      }

      expect(result).to eq(expected)
    end
  end

  describe '#flight_winners' do
    it 'extracts and organises the flight winners' do
      result = subject.flight_winners

      expected = {
        'gold'   => [
          { 'brewer' => 'Fraser Withers', 'beer' => { 'name' => 'Blue Jay', 'style' => '19A' } },
          { 'brewer' => 'Fraser Withers', 'beer' => { 'name' => 'Cross Roads', 'style' => '18B' } },
          { 'brewer' => 'Mark Sanderson', 'beer' => { 'name' => 'Daisycutter', 'style' => '1C', 'asst_brewer' => 'Rob Gallagher' } },
          { 'brewer' => 'Mike Carter', 'beer' => { 'name' => 'Dead Fly In The Wax', 'style' => '22C' } },
          { 'brewer' => 'Phill Turner', 'beer' => { 'name' => 'Georgijs Voshington Porter', 'style' => '20A' } }
        ],
        'silver' => [
          { 'brewer' => 'Jeremiah Petersen', 'beer' => { 'name' => 'Magical Realism', 'style' => '28A' } },
          { 'brewer' => 'Mark Charlwood', 'beer' => { 'name' => 'Falconer\'s Flight', 'style' => '44A' } },
          { 'brewer' => 'Matt Simmons', 'beer' => { 'name' => 'Seven Point Four IPA', 'style' => '21A' } },
          { 'brewer' => 'Paul Spearman', 'beer' => { 'name' => 'Paul\'s AAA', 'style' => '19A' } },
          { 'brewer' => 'Phill Turner', 'beer' => { 'name' => 'Not Ranke XX Bitter', 'style' => '21B' } }
        ],
        'bronze' => [
          { 'brewer' => 'James Wilson', 'beer' => { 'name' => 'Shot To Nothing', 'style' => '18B' } },
          { 'brewer' => 'Jonathan Finch', 'beer' => { 'name' => 'Winston Salem Wheat', 'style' => '1D' } },
          { 'brewer' => 'Mark Charlwood', 'beer' => { 'name' => 'New England IPA', 'style' => '21B' } },
          { 'brewer' => 'Mark Sanderson', 'beer' => { 'name' => 'Amber Gambler', 'style' => '19A' } }
        ]
      }

      expect(result['gold']).to eq(expected['gold'])
      expect(result['silver']).to eq(expected['silver'])
      expect(result['bronze']).to eq(expected['bronze'])
    end
  end
end
