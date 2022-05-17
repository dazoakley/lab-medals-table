# frozen_string_literal: true

require 'erb'

module LAB
  class RollOfHonourBuilder
    class << self
      def build
        template = ERB.new(File.read(File.join(__dir__, 'roll_of_honour.html.erb')), trim_mode: '>')
        template.result(binding)
      end
    end
  end
end
