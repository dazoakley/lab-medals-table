# frozen_string_literal: true

require 'spec_helper'

RSpec.describe LAB::Beer do
  describe '#total_points' do
    before do
      stub_database
    end

    it 'returns the total points for a brewers winning beers' do
      expect(LAB::Beer.find(name: 'Cool As A Kiwi').total_points).to eq 15
      expect(LAB::Beer.find(name: 'Mayday Leap').total_points).to eq 20
    end
  end
end
