# frozen_string_literal: true

require 'spec_helper'

RSpec.describe LAB::CsvExportBuilder do
  before do
    stub_database
  end

  describe '.build' do
    it 'runs' do
      csv = described_class.build

      expect(csv).to_not be_empty
      expect(csv).to include('2019,NAWB National,NGWBJ,Lee Immins,Pale Lager,NONE,NONE,gold')
      expect(csv).to include('2020,Lager Than Life,BJCP 2015,Dave Strachan,Holy Smokes,Rauchbier,6B,gold,gold')
    end
  end
end
