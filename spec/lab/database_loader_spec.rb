# frozen_string_literal: true

require 'spec_helper'

RSpec.describe LAB::DatabaseLoader do
  let(:competitions_dir) { File.join(File.dirname(__FILE__), '../fixtures/') }
  let(:guidelines_dir) { File.join(File.dirname(__FILE__), '../../styles/') }

  subject { described_class.new(DB, competitions_dir, guidelines_dir) }

  describe '#load_guidelines' do
    it 'should load the guidelines table' do
      expect(DB[:guidelines].count).to eq(0)

      subject.load_guidelines

      expect(DB[:guidelines].count).to eq(6)
    end

    it 'should load the styles table' do
      expect(DB[:styles].count).to eq(0)

      subject.load_guidelines

      bjcp2015 = LAB::Guideline.find(name: 'BJCP 2015')

      expect(bjcp2015.styles.count).to be(144)

      light_lager = LAB::Style.find(guideline_id: bjcp2015.id, number: '1A')

      expect(light_lager).to_not be(nil)
      expect(light_lager.name).to eq('American Light Lager')
    end
  end

  describe '#load_competitions' do
    before do
      subject.load_guidelines
    end

    it 'should load the competitions table' do
      expect(DB[:competitions].count).to eq(0)

      subject.load_competitions

      expect(DB[:competitions].count).to eq(5)
    end

    it 'should load the locations table' do
      expect(DB[:locations].count).to eq(0)

      subject.load_competitions

      expect(DB[:locations].count).to eq(4)
    end

    it 'should load the competition_editions table' do
      expect(DB[:competition_editions].count).to eq(0)

      subject.load_competitions

      expect(DB[:competition_editions].count).to eq(6)
    end

    it 'should load the brewers table' do
      expect(DB[:brewers].count).to eq(0)

      subject.load_competitions

      expect(DB[:brewers].count).to eq(21)
    end

    it 'should load the beers table' do
      expect(DB[:beers].count).to eq(0)

      subject.load_competitions

      expect(DB[:beers].count).to eq(35)
    end

    it 'should load unknown styles into the styles table' do
      expect(DB[:styles].count).to eq(340)

      subject.load_competitions

      expect(DB[:styles].count).to eq(345)
    end

    it 'should load the results table' do
      expect(DB[:results].count).to eq(0)

      subject.load_competitions

      expect(DB[:results].count).to eq(40)
      expect(DB[:results].where(round: 'flight').count).to eq(35)
      expect(DB[:results].where(round: 'bos').count).to eq(5)
    end
  end
end
