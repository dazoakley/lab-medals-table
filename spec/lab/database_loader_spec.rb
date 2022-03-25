# frozen_string_literal: true

require 'spec_helper'

RSpec.describe LAB::DatabaseLoader do
  let(:competitions_dir) { File.join(File.dirname(__FILE__), '../fixtures/') }
  let(:guidelines_dir) { File.join(File.dirname(__FILE__), '../../styles/') }

  subject { described_class.new(DB, competitions_dir, guidelines_dir) }

  describe '#load_guidelines' do
    it 'should load the guidelines table' do
      expect(DB['guidelines'].count).to eq(0)

      subject.load_guidelines

      expect(DB['guidelines'].count).to eq(4)
    end

    it 'should load the styles table' do
      expect(DB['styles'].count).to eq(0)

      subject.load_guidelines

      bjcp2015 = LAB::Guideline.find(name: 'BJCP 2015')

      expect(bjcp2015.styles.count).to be(144)

      light_lager = LAB::Style.find(guideline_id: bjcp2015.id, number: '1A')

      expect(light_lager).to_not be(nil)
      expect(light_lager.name).to eq('American Light Lager')
    end
  end
end
