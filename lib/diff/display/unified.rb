module Diff
  module Display
    class Unified
      def initialize(udiff)
        @data = Diff::Display::Unified::Generator.run(udiff)
      end
      attr_reader :data
      
      def render(renderer, out="")
        out << renderer.render
      end
    end
  end
end