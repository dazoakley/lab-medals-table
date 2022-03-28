# frozen_string_literal: true

require 'spec_helper'

RSpec.describe LAB::Result do
  describe '#score' do
    describe 'when the result is a "flight" round' do
      let(:result) { LAB::Result.new(round: 'flight') }

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
      let(:result) { LAB::Result.new(round: 'bos') }

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
end
