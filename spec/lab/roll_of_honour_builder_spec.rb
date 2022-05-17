# frozen_string_literal: true

require 'spec_helper'

RSpec.describe LAB::RollOfHonourBuilder do
  before do
    stub_database
  end

  describe '.build' do
    it 'runs' do
      html = described_class.build

      expect(html).to_not be_empty
      expect(html).to include('<dd>')
    end
  end
end
