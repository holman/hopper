module Hopper
  module Views
    class Probe < Layout
      def title
        @probe.name
      end

      def probes
        Hopper::Probe.all
      end

      def probe
        @probe
      end

      def aggregates
        @probe.aggregates
      end

      def averages
        @probe.averages
      end
    end
  end
end