# frozen_string_literal: true

require 'spec_helper'

RSpec.describe LAB::PointsOverTimeBuilder do
  before do
    stub_database
  end

  describe '.build' do
    it 'runs' do
      csv = described_class.build

      expect(csv).to_not be_empty
      expect(csv).to include('Mick Harrison,0,0,2.5,2.5,2.5,2.5')
      expect(csv).to include('Mark Sanderson,0,25,25,37.5,37.5,40')
    end
  end

  describe '.brewer_points_per_competition_edition' do
    it 'collates all the points won for each competition edition per brewer' do
      data = described_class.brewer_points_per_competition_edition

      expect(data.keys.count).to eq(17)
      expect(data['Mick Harrison']).to eq([0, 0, 2.5, 0, 0, 0])
      expect(data['Mark Sanderson']).to eq([0, 25, 0, 12.5, 0, 2.5])
    end

    it 'should not include brewers with zero points overall' do
      data = described_class.brewer_points_per_competition_edition

      expect(data.keys).to_not include('Charlie Cat')
    end
  end

  describe '.brewer_points_over_time' do
    it 'calculates the points won over time for each brewer' do
      data = described_class.brewer_points_over_time

      expect(data.keys.count).to eq(17)
      expect(data['Mick Harrison']).to eq([0, 0, 2.5, 2.5, 2.5, 2.5])
      expect(data['Mark Sanderson']).to eq([0, 25, 25, 37.5, 37.5, 40])
    end

    it 'should not include brewers with zero points overall' do
      data = described_class.brewer_points_over_time

      expect(data.keys).to_not include('Charlie Cat')
    end
  end
end
