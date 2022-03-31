# frozen_string_literal: true

require 'spec_helper'

RSpec.describe LAB::TableBuilder do
  before do
    stub_database
  end

  describe '.build' do
    it 'runs' do
      html = described_class.build

      expect(html).to_not be_empty
      expect(html).to include('<table>')
    end
  end
end
