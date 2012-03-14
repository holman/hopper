module Hopper
  module Views
    class Probe < Layout
      def probe
        @probe
      end

      def aggregates
        @probe.aggregates
      end
    end
  end
end