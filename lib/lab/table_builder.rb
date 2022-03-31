# frozen_string_literal: true

require 'erb'

module LAB
  class TableBuilder
    class << self
      def build
        template = ERB.new(File.read(File.join(__dir__, 'table.html.erb')))
        template.result(binding)
      end
    end
  end
end
